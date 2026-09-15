use std::collections::HashSet;

pub fn check(candidate: &str) -> bool {
    let mut char_set = HashSet::new();
    
    candidate
        .chars()
        .filter(|&ch| ch != '-' && ch != ' ')
        .map(|ch| ch.to_ascii_lowercase())
        .all(|ch| char_set.insert(ch))
}
