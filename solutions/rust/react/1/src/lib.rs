use std::collections::{HashMap, HashSet};

/// `InputCellId` is a unique identifier for an input cell.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct InputCellId(usize);

struct InputCell<T> {
    value: T,
}

impl<T: Copy + PartialEq> InputCell<T> {
    fn new(init: T) -> Self {
        Self { value: init }
    }
}
/// `ComputeCellId` is a unique identifier for a compute cell.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct ComputeCellId(usize);

struct ComputeCell<'a, T> {
    dependencies: Vec<CellId>,
    compute_func: Box<dyn Fn(&[T]) -> T + 'a>,
    value: T,
    changed: bool,
    cbs: HashMap<CallbackId, Box<dyn FnMut(T) + 'a>>,
    cb_id: usize,
}

impl<'a, T: Copy + PartialEq> ComputeCell<'a, T> {
    fn new(dependencies: Vec<CellId>, compute_func: Box<dyn Fn(&[T]) -> T + 'a>, value: T) -> Self {
        Self {
            dependencies,
            compute_func,
            value,
            changed: false,
            cbs: HashMap::new(),
            cb_id: 0,
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct CallbackId(usize);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CellId {
    Input(InputCellId),
    Compute(ComputeCellId),
}

#[derive(Debug, PartialEq, Eq)]
pub enum RemoveCallbackError {
    NonexistentCell,
    NonexistentCallback,
}

pub struct Reactor<'a, T> {
    inputs: HashMap<InputCellId, InputCell<T>>,
    computes: HashMap<ComputeCellId, ComputeCell<'a, T>>,
    input_id: usize,
    compute_id: usize,
}

impl<'a, T: Copy + PartialEq> Reactor<'a, T> {
    pub fn new() -> Self {
        Self {
            inputs: HashMap::new(),
            computes: HashMap::new(),
            input_id: 0,
            compute_id: 0,
        }
    }

    // Creates an input cell with the specified initial value, returning its ID.
    pub fn create_input(&mut self, initial: T) -> InputCellId {
        let cell = InputCell::new(initial);
        let id = InputCellId(self.input_id);
        self.inputs.insert(InputCellId(self.input_id), cell);
        self.input_id += 1;
        id
    }

    // Creates a compute cell with the specified dependencies and compute function.
    pub fn create_compute<F: Fn(&[T]) -> T + 'static>(
        &mut self,
        dependencies: &[CellId],
        compute_func: F,
    ) -> Result<ComputeCellId, CellId> {
        if let Some(&missing) = dependencies.iter().find(|id| match **id {
            CellId::Input(id) => !self.inputs.contains_key(&id),
            CellId::Compute(id) => !self.computes.contains_key(&id),
        }) {
            return Err(missing);
        }
    
        let values: Vec<T> = dependencies.iter().map(|id| match id {
            CellId::Input(id) => self.inputs[id].value,
            CellId::Compute(id) => self.computes[id].value,
        }).collect();
    
        let value = compute_func(&values);
    
        let id = ComputeCellId(self.compute_id);
        self.compute_id += 1;
        let cell = ComputeCell::new(dependencies.to_vec(), Box::new(compute_func), value);
        self.computes.insert(id, cell);
        Ok(id)
    }

    // Retrieves the current value of the cell, or None if the cell does not exist.
    pub fn value(&self, id: CellId) -> Option<T> {
        match id {
            CellId::Input(id) => {
                let cell = self.inputs.get(&id)?;
                Some(cell.value)
            }
            CellId::Compute(id) => {
                let cell = self.computes.get(&id)?;
                Some(cell.value)
            }
        }
    }

    // Sets the value of the specified input cell.
    pub fn set_value(&mut self, id: InputCellId, new_value: T) -> bool {
        match self.inputs.get_mut(&id) {
            Some(c) => c.value = new_value,
            None => return false,
        }

        let target = CellId::Input(id);
        let affected: HashSet<ComputeCellId> = self
            .computes
            .keys()
            .copied()
            .filter(|cid| self.depends_on(*cid, target))
            .collect();

        let mut visited: HashSet<ComputeCellId> = HashSet::new();
        for cid in affected.iter().copied() {
            self.recompute(cid, &affected, &mut visited);
        }

        for cid in affected {
            if let Some(cell) = self.computes.get_mut(&cid) {
                if cell.changed {
                    let v = cell.value;
                    for cb in cell.cbs.values_mut() {
                        cb(v);
                    }
                    cell.changed = false; 
                }
            }
        }

        true
    }

    fn depends_on(&self, cid: ComputeCellId, target: CellId) -> bool {
        let cell = match self.computes.get(&cid) {
            Some(c) => c,
            None => return false,
        };
        for dep in &cell.dependencies {
            if *dep == target {
                return true;
            }
            if let CellId::Compute(dep_cid) = dep {
                if self.depends_on(*dep_cid, target) {
                    return true;
                }
            }
        }
        false
    }

    fn recompute(
        &mut self,
        cid: ComputeCellId,
        affected: &HashSet<ComputeCellId>,
        visited: &mut HashSet<ComputeCellId>,
    ) {
        if !visited.insert(cid) {
            return; 
        }

        let deps: Vec<CellId> = match self.computes.get(&cid) {
            Some(c) => c.dependencies.clone(),
            None => return,
        };
        for dep in &deps {
            if let CellId::Compute(dep_cid) = dep {
                if affected.contains(dep_cid) {
                    self.recompute(*dep_cid, affected, visited);
                }
            }
        }

        let values: Vec<T> = deps
            .iter()
            .map(|dep| self.value(*dep).expect("dependency exists"))
            .collect();

        let new_val = {
            let func = &self.computes[&cid].compute_func;
            func(&values)
        };

        let cell = self.computes.get_mut(&cid).unwrap();
        cell.changed = cell.value != new_val;
        cell.value = new_val;
    }

    // Adds a callback to the specified compute cell.
    pub fn add_callback<F: FnMut(T) + 'a>(
        &mut self,
        id: ComputeCellId,
        callback: F,
    ) -> Option<CallbackId> {
        let compute_cell = self.computes.get_mut(&id)?;
        let cb = Box::new(callback);
        let cb_id = CallbackId(compute_cell.cb_id);
        compute_cell.cbs.insert(CallbackId(compute_cell.cb_id), cb);
        compute_cell.cb_id += 1;
        Some(cb_id)
    }

    // Removes the specified callback, using an ID returned from add_callback.
    pub fn remove_callback(
        &mut self,
        cell: ComputeCellId,
        callback: CallbackId,
    ) -> Result<(), RemoveCallbackError> {
        let compute_cell = match self.computes.get_mut(&cell) {
            Some(c) => c,
            None => return Err(RemoveCallbackError::NonexistentCell),
        };

        match compute_cell.cbs.remove(&callback) {
            None => Err(RemoveCallbackError::NonexistentCallback),
            Some(_) => Ok(()),
        }
    }
}
