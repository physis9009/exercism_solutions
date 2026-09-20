pub fn translate(input: &str) -> String {
    input
        .split_whitespace()
        .map(translate_word)
        .collect::<Vec<_>>()
        .join(" ")
}

fn translate_word(word: &str) -> String {
    if word.starts_with(['a', 'e', 'i', 'o', 'u']) || word.starts_with("xr") || word.starts_with("yt") {
        return format!("{}ay", word);
    }

    let char_vec: Vec<char> = word.chars().collect();
    let mut original = String::from(word);

    let start = if word.starts_with('y') {1} else {0};
    let (end, init) = if let Some(i_qu) = word.find("qu") {(i_qu, i_qu + 2)} else {(word.len(), 0)};

    let mut index = init;
    for i in start..end {
        if "aeiou".contains(char_vec[i]) || char_vec[i] == 'y' {
            index = i;
            break;
        }
    }
    let mut result = original.split_off(index);
    result.push_str(&original);
    result.push_str("ay");
    result
}