pub fn raindrops(n: u32) -> String {
    let mut sounds = String::new();
    match (n.is_multiple_of(3), n.is_multiple_of(5), n.is_multiple_of(7)) {
        (false, false, false) => sounds.push_str(n.to_string().as_str()),
        (a, b, c) => {
            if a { sounds.push_str("Pling"); }
            if b { sounds.push_str("Plang"); }
            if c { sounds.push_str("Plong"); }
        },
    }

    sounds
}
