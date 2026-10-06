use std::collections::HashSet;
use std::hash::Hash;

#[derive(Debug, PartialEq, Eq)]
pub struct CustomSet<T: Eq + Hash> {
    values: HashSet<T>,
}

impl<T: Eq + Hash> CustomSet<T> {
    pub fn new(input: &[T]) -> Self 
    where
        T: Clone,
    {
        let mut values = HashSet::new();
        for n in input.iter() {
            values.insert(n.clone());
        }
        CustomSet { values }
    }

    pub fn contains(&self, element: &T) -> bool {
        self.values.contains(element)
    }

    pub fn add(&mut self, element: T) {
        self.values.insert(element);
    }

    pub fn is_subset(&self, other: &Self) -> bool {
        self.values.is_subset(&other.values)
    }

    pub fn is_empty(&self) -> bool {
        self.values.is_empty()
    }

    pub fn is_disjoint(&self, other: &Self) -> bool {
        self.values.is_disjoint(&other.values)
    }

    #[must_use]
    pub fn intersection<'a>(&'a self, other: &'a Self) -> Self 
    where
        T: Clone,
    {
        let values = self.values.intersection(&other.values).cloned().collect();
        Self { values }
    }

    #[must_use]
    pub fn difference<'a>(&'a self, other: &'a Self) -> Self 
    where
        T: Clone,
    {
        let values = self.values.difference(&other.values).cloned().collect();
        Self { values }
    }

    #[must_use]
    pub fn union<'a>(&'a self, other: &'a Self) -> Self 
    where
        T: Clone,
    {
        let values = self.values.union(&other.values).cloned().collect();
        Self { values }
    }
}
