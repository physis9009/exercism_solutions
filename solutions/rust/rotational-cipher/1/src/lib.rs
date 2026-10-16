pub fn rotate(input: &str, key: u8) -> String {
    input
        .chars()
        .map(|ch| {
            match ch.is_ascii_alphabetic() {
                true => match ch.is_ascii_lowercase() {
                    true => {
                        let i = ch as u8 - 97;
                        let new_i = (i + key) % 26;
                        char::from_u32(new_i as u32 + 97).unwrap()
                    }
                    false => {
                        let i = ch as u8 - 65;
                        let new_i = (i + key) % 26;
                        char::from_u32(new_i as u32 + 65).unwrap()
                    }
                }
                false => ch,
            }
        })
        .collect()
}
