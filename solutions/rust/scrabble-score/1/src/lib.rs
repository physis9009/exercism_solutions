use std::sync::LazyLock;
use std::collections::HashMap;

static MAP: LazyLock<HashMap<char, u64>> = LazyLock::new(|| {
    HashMap::from([
        ('a', 1), ('e', 1), ('i', 1), ('o', 1), ('u', 1), ('l', 1), ('n', 1), ('r', 1),
        ('s', 1), ('t', 1), ('d', 2), ('g', 2), ('b', 3), ('c', 3), ('m', 3), ('p', 3),
        ('f', 4), ('h', 4), ('v', 4), ('w', 4), ('y', 4), ('k', 5), ('j', 8), ('x', 8),
        ('q', 10), ('z', 10)
    ])
});

pub fn score(word: &str) -> u64 {
    word
        .to_lowercase()
        .chars()
        .map(|ch| {
            if let Some(&val) = MAP.get(&ch) {
                val
            } else { 0 }
        })
        .sum()
}
