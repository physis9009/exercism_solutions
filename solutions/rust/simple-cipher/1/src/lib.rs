use rand::random_range;

pub fn encode(key: &str, s: &str) -> Option<String> {
    if key.is_empty()
        || s.is_empty()
        || !key.chars().all(|c| c.is_ascii_lowercase())
        || !s.chars().all(|c| c.is_ascii_lowercase())
    { return None; }

    Some(s.chars()
            .zip(key.chars().cycle())
            .map(|(c, k)| {
                let shift = (c as u8 - b'a' + k as u8 - b'a') % 26;
                (b'a' + shift) as char
            })
            .collect())
}

pub fn decode(key: &str, s: &str) -> Option<String> {
    if key.is_empty()
        || s.is_empty()
        || !key.chars().all(|c| c.is_ascii_lowercase())
        || !s.chars().all(|c| c.is_ascii_lowercase())
    { return None; }

    Some(s.chars()
            .zip(key.chars().cycle())
            .map(|(c, k)| {
                let shift = (c as u8 - b'a' + 26 - (k as u8 - b'a')) % 26;
                (b'a' + shift) as char
            })
            .collect())
}

pub fn encode_random(s: &str) -> (String, String) {
    let mut key_num: Vec<u8> = Vec::new();
    for _ in 0..100 {
        key_num.push(random_range(0..26));
    }

    let key: String = key_num.into_iter().map(|n| (n + b'a') as char).collect();
    
    ( key.clone(), encode(key.as_str(), s).unwrap() )
}
