use rand::{Rng, RngExt};
use std::cell::RefCell;
use std::collections::HashSet;
use std::rc::Rc;

pub struct RobotFactory {
    used: Rc<RefCell<HashSet<String>>>,
}

pub struct Robot {
    used: Rc<RefCell<HashSet<String>>>,
    name: String,
}

impl RobotFactory {
    pub fn new() -> Self {
        Self { used: Rc::new(RefCell::new(HashSet::new())) }
    }

    pub fn new_robot<R: Rng>(&mut self, rng: &mut R) -> Robot {
        loop {
            let name = Self::random_name(rng);
            if self.used.borrow_mut().insert(name.clone()) {
                return Robot {
                    used: Rc::clone(&self.used),
                    name,
                };
            }
        }
    }

    fn random_name<R: Rng>(rng: &mut R) -> String {
        let letters: String = (0..2)
            .map(|_| rng.random_range(b'A'..=b'Z') as char)
            .collect();
        let digits: String = (0..3)
            .map(|_| rng.random_range(b'0'..=b'9') as char)
            .collect();
        format!("{letters}{digits}")
    }
}

impl Robot {
    pub fn name(&self) -> &str {
        self.name.as_str()
    }

    pub fn reset<R: Rng>(&mut self, rng: &mut R) {
        self.used.borrow_mut().remove(&self.name);
        loop {
            let new_name = RobotFactory::random_name(rng);
            if self.used.borrow_mut().insert(new_name.clone()) {
                self.name = new_name;
                break;
            }
        }
    }
}