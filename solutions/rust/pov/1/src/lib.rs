use std::cell::RefCell;
use std::cmp::Ordering;
use std::fmt::Debug;
use std::rc::{Rc, Weak};

struct Node<T: Debug + Ord> {
    value: T,
    parent: Option<Weak<RefCell<Node<T>>>>,
    children: Vec<Rc<RefCell<Node<T>>>>,
}

impl<T: Debug + Ord> Node<T> {
    fn new(value: T) -> Self {
        Node { value, parent: None, children: Vec::new() }
    }
}

impl<T: Debug + Ord> Debug for Node<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Node").field("value", &self.value).finish()
    }
}

impl<T: Debug + Ord> PartialEq for Node<T> {
    fn eq(&self, other: &Self) -> bool {
        if self.value != other.value || self.children.len() != other.children.len() {
            return false;
        }
        let mut used = vec![false; other.children.len()];
        for a in &self.children {
            let mut matched = false;
            for (i, b) in other.children.iter().enumerate() {
                if used[i] {
                    continue;
                }
                if Rc::ptr_eq(a, b) || *a.borrow() == *b.borrow() {
                    used[i] = true;
                    matched = true;
                    break;
                }
            }
            if !matched {
                return false;
            }
        }
        true
    }
}

impl<T: Debug + Ord> Eq for Node<T> {}

impl<T: Debug + Ord> PartialOrd for Node<T> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl<T: Debug + Ord> Ord for Node<T> {
    fn cmp(&self, other: &Self) -> Ordering {
        self.value.cmp(&other.value).then_with(|| {
            let mut a: Vec<_> = self.children.iter().collect();
            let mut b: Vec<_> = other.children.iter().collect();
            a.sort_by(|x, y| x.borrow().cmp(&y.borrow()));
            b.sort_by(|x, y| x.borrow().cmp(&y.borrow()));
            for (x, y) in a.iter().zip(b.iter()) {
                let o = x.borrow().cmp(&y.borrow());
                if o != Ordering::Equal {
                    return o;
                }
            }
            a.len().cmp(&b.len())
        })
    }
}

pub struct Tree<T: Debug + Ord> {
    root: Rc<RefCell<Node<T>>>,
}

impl<T: Debug + Ord> Debug for Tree<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Tree").field("root", &*self.root.borrow()).finish()
    }
}

impl<T: Debug + Ord> PartialEq for Tree<T> {
    fn eq(&self, other: &Self) -> bool {
        *self.root.borrow() == *other.root.borrow()
    }
}

impl<T: Debug + Ord> Eq for Tree<T> {}

impl<T: Debug + Ord> PartialOrd for Tree<T> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl<T: Debug + Ord> Ord for Tree<T> {
    fn cmp(&self, other: &Self) -> Ordering {
        self.root.borrow().cmp(&other.root.borrow())
    }
}

impl<T: Debug + Ord> Tree<T> {
    pub fn new(label: T) -> Self {
        Self { root: Rc::new(RefCell::new(Node::new(label))) }
    }

    pub fn with_child(self, child: Self) -> Self {
        child.root.borrow_mut().parent = Some(Rc::downgrade(&self.root));
        self.root.borrow_mut().children.push(child.root);
        self
    }

    pub fn pov_from(&mut self, from: &T) -> bool {
        let Some(new_root) = find_node(&self.root, from) else {
            return false;
        };

        let mut chain: Vec<Rc<RefCell<Node<T>>>> = vec![Rc::clone(&new_root)];
        let mut cur = new_root.borrow().parent.as_ref().and_then(Weak::upgrade);
        while let Some(node) = cur {
            cur = node.borrow().parent.as_ref().and_then(Weak::upgrade);
            chain.push(node);
        }

        for i in 0..chain.len() - 1 {
            detach(&chain[i + 1], &chain[i]);
            attach(&chain[i], &chain[i + 1]);
        }

        new_root.borrow_mut().parent = None;
        self.root = new_root;
        true
    }

    pub fn path_between<'a>(&'a mut self, from: &'a T, to: &'a T) -> Option<Vec<&'a T>> {
        let from_node = find_node(&self.root, from)?;
        let to_node = find_node(&self.root, to)?;
    
        let mut from_path: Vec<Rc<RefCell<Node<T>>>> = vec![Rc::clone(&from_node)];
        let mut cur = from_node.borrow().parent.as_ref().and_then(Weak::upgrade);
        while let Some(n) = cur {
            cur = n.borrow().parent.as_ref().and_then(Weak::upgrade);
            from_path.push(n);
        }
    
        let mut to_path: Vec<Rc<RefCell<Node<T>>>> = Vec::new();
        let mut cur = Some(Rc::clone(&to_node));
        while let Some(n) = cur {
            if let Some(pos) = from_path.iter().position(|x| Rc::ptr_eq(x, &n)) {
                let mut result: Vec<Rc<RefCell<Node<T>>>> = Vec::new();
                result.extend(from_path[0..=pos].iter().cloned());
                for node in to_path.iter().rev() {
                    result.push(Rc::clone(node));
                }
                let refs: Vec<&'a T> = result
                    .iter()
                    .map(|rc| unsafe { node_value_ref::<'a, T>(rc) })
                    .collect();
                return Some(refs);
            }
            to_path.push(Rc::clone(&n));
            cur = n.borrow().parent.as_ref().and_then(Weak::upgrade);
        }
    
        None
    }
}

fn find_node<T: Debug + Ord>(
    node: &Rc<RefCell<Node<T>>>,
    from: &T,
) -> Option<Rc<RefCell<Node<T>>>> {
    if node.borrow().value == *from {
        return Some(Rc::clone(node));
    }
    let children: Vec<_> = node.borrow().children.iter().cloned().collect();
    for child in children {
        if let Some(found) = find_node(&child, from) {
            return Some(found);
        }
    }
    None
}

fn attach<T: Debug + Ord>(p: &Rc<RefCell<Node<T>>>, c: &Rc<RefCell<Node<T>>>) {
    p.borrow_mut().children.push(Rc::clone(c));
    c.borrow_mut().parent = Some(Rc::downgrade(p));
}

fn detach<T: Debug + Ord>(p: &Rc<RefCell<Node<T>>>, c: &Rc<RefCell<Node<T>>>) {
    p.borrow_mut().children.retain(|x| !Rc::ptr_eq(x, c));
    c.borrow_mut().parent = None;
}

unsafe fn node_value_ref<'a, T: Debug + Ord>(rc: &Rc<RefCell<Node<T>>>) -> &'a T {
    let cell: *const RefCell<Node<T>> = Rc::as_ptr(rc);
    let node: *mut Node<T> = (*cell).as_ptr();
    unsafe { &(*node).value }
}