pub fn hamming_distance(s1: &str, s2: &str) -> Option<usize> {
    if s1.len() != s2.len() { return None; }

    let count = s1.chars().zip(s2.chars()).filter(|(ch1, ch2)| ch1 != ch2).count();
    Some(count)
}
