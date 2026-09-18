use std::collections::HashSet;

pub fn is_pangram(sentence: &str) -> bool {
    let seen: HashSet<char> = sentence
        .to_lowercase()
        .chars()
        .filter(|ch| ch.is_ascii_alphabetic())
        .collect();
    seen.len() == 26
}
