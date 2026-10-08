use std::{
    collections::HashMap,
    sync::LazyLock,
};

static MAP: LazyLock<HashMap<char, char>> = LazyLock::new(|| {
    ('a'..='z').zip(('a'..='z').rev()).collect::<HashMap<char, char>>()
});

pub fn encode(plain: &str) -> String {
    plain.chars()
        .filter_map(|ch| {
            match (ch.is_ascii_alphabetic(), ch.is_ascii_digit()) {
                (true, _) => MAP.get(&ch.to_ascii_lowercase()).copied(),
                (_, true) => Some(ch),
                (_, _) => None,
            }
        })
        .enumerate()
        .flat_map(|(i, ch)| {
            if i > 0 && i.is_multiple_of(5) {
                vec![' ', ch]
            } else { vec![ch] }
        })
        .collect()
}

pub fn decode(cipher: &str) -> String {
    cipher.chars()
        .filter_map(|ch| {
            match (ch.is_ascii_alphabetic(), ch.is_ascii_digit()) {
                (true, _) => MAP.get(&ch).copied(),
                (_, true) => Some(ch),
                (_, _) => None,
            }
        })
        .collect()
}
