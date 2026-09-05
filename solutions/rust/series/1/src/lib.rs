pub fn series(digits: &str, len: usize) -> Vec<String> {
    let mut sub_strs = Vec::new();
    for sub_str in digits.chars().collect::<Vec<_>>().windows(len) {
        sub_strs.push(sub_str.iter().collect());
    }

    sub_strs
}
