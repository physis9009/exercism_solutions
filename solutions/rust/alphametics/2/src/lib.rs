use std::collections::{HashMap, HashSet};
use std::iter::once;

pub fn solve(input: &str) -> Option<HashMap<char, u8>> {
    let mut parts = input.split(" == ");
    let addends: Vec<&str> = parts.next()?.split(" + ").collect();
    let sum = parts.next()?;
    
    let letters: HashSet<char> = addends.iter()
        .flat_map(|w| w.chars())
        .chain(sum.chars())
        .collect();
    
    let first_letters: HashSet<char> = addends.iter()
        .map(|w| w.chars().next().unwrap())
        .chain(once(sum.chars().next().unwrap()))
        .collect();
    
    let letters_vec: Vec<char> = letters.into_iter().collect();
    let mut assignment = HashMap::new();
    let mut used = [false; 10];
     
    if search(0, &letters_vec, &first_letters, &mut assignment, &mut used, &addends, sum) {
        Some(assignment)
    } else {
        None
    }
}

fn search(
    idx: usize,
    letters: &[char],
    first_letters: &HashSet<char>,
    assignment: &mut HashMap<char, u8>,
    used: &mut [bool; 10],
    addends: &[&str],
    sum: &str,
) -> bool {
    if idx == letters.len() {
        return eval(addends, sum, assignment);
    }

    let letter = letters[idx];
    for digit in 0..=9 {
        if used[digit] || (first_letters.contains(&letter) && digit == 0) { continue; }

        used[digit] = true;
        assignment.insert(letter, digit as u8);

        if search(idx + 1, letters, first_letters, assignment, used, addends, sum) { return true; }

        used[digit] = false;
        assignment.remove(&letter);
    }
    false
}

fn eval(addends: &[&str], sum: &str, assignment: &HashMap<char, u8>) -> bool {
    let word_to_num = |word: &str| -> u64 {
        word.chars().fold(0, |acc, c| acc * 10 + *assignment.get(&c).unwrap() as u64)
    };
    
    let sum_left: u64 = addends.iter().map(|w| word_to_num(w)).sum();
    let sum_right = word_to_num(sum);
    sum_left == sum_right
}