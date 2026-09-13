use std::collections::{HashMap, HashSet};

pub struct School<'a> {
    names: HashSet<&'a str>,
    roster: HashMap<u32, Vec<&'a str>>,
}

impl<'a> School<'a> {
    pub fn new() -> School<'a> {
        let names: HashSet<&'a str> = HashSet::new();
        let roster: HashMap<u32, Vec<&'a str>> = HashMap::new();
        School {names, roster}
    }

    pub fn add(&mut self, grade: u32, student: &'a str) {
        if self.names.contains(&student) == false {
            self.names.insert(student);
            match self.roster.get_mut(&grade) {
                Some(roster) => roster.push(student),
                None => { self.roster.insert(grade, vec![student]); }
            }
        }
    }

    pub fn grades(&self) -> Vec<u32> {
        let mut all_grades: Vec<u32> = self.roster.keys().copied().collect();
        all_grades.sort();
        all_grades
    }

    pub fn grade(&self, grade: u32) -> Vec<String> {
        match self.roster.get(&grade) {
            None => Vec::<String>::new(),
            Some(roster) => {
                let mut vec_str = roster.iter()
                    .map(|name| name.chars().collect::<String>())
                    .collect::<Vec<String>>();
                vec_str.sort_by_key(|a| a
                                .chars()
                                .next()
                                .unwrap());
                
                vec_str
            }
        }
    }
}
