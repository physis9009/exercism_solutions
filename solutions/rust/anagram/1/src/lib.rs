use std::collections::HashSet;

pub fn anagrams_for<'a>(word: &str, possible_anagrams: &'a [&'a str]) -> HashSet<&'a str> {
    let lowercased = word.to_lowercase();
    let mut char_set: Vec<char> = lowercased.chars().collect();
    char_set.sort_unstable();
    let mut anagrams = HashSet::new();
    
    for &candidate in possible_anagrams {
        let candidate_lower = candidate.to_lowercase();
        if candidate_lower != lowercased {
            let mut candidate_chars: Vec<char> = candidate_lower.chars().collect();
            candidate_chars.sort_unstable();
            if candidate_chars == char_set {
                anagrams.insert(candidate);
            }
        }
    }
    
    anagrams
}
