use std::collections::HashMap;

pub fn word_count(words: &str) -> HashMap<String, u32> {
    fn spliter(ch: char) -> bool {
        (ch.is_ascii_punctuation() && ch != '\'')
            || ch.is_ascii_whitespace()
    }
    
    let mut result_map: HashMap<String, u32> = HashMap::new();
    for word in words
        .to_lowercase()
        .split(spliter)
        .into_iter() {
            let trimmed = word.trim_matches('\'');
            if !trimmed.is_empty() {
                result_map.entry(trimmed.to_string())
                    .and_modify(|c| *c += 1)
                    .or_insert(1);
            }
        }

    result_map
}
