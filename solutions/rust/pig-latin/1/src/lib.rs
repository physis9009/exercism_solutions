pub fn translate(input: &str) -> String {
    input
        .split_whitespace()
        .map(translate_word)
        .collect::<Vec<_>>()
        .join(" ")
}

fn translate_word(input: &str) -> String {
    if first_vowel(input) == Some(0) || input.starts_with("xr") || input.starts_with("yt") {
        return format!("{}ay", input);
    }

    let mut input_string = String::from(input);

    let fv = first_vowel(input);
    let qu = first_qu(input);
    let ys = all_y(input);

    if let Some(qi) = qu {
        if fv.is_none() || fv.unwrap() > qi {
            let tail = input_string.split_off(qi + 2);
            let mut output = String::from(tail);
            output.push_str(&input_string);
            output.push_str("ay");
            return output;
        }
    }

    for &yi in &ys {
        if yi > 0 && (fv.is_none() || fv.unwrap() > yi) {
            let tail = input_string.split_off(yi);
            let mut output = String::from(tail);
            output.push_str(&input_string);
            output.push_str("ay");
            return output;
        }
    }

    if let Some(vi) = fv {
        if vi > 0 {
            let tail = input_string.split_off(vi);
            let mut output = String::from(tail);
            output.push_str(&input_string);
            output.push_str("ay");
            return output;
        }
    }

    input_string.push_str("ay");
    input_string
}

fn first_vowel(input: &str) -> Option<usize> {
    for (i, ch) in input.chars().enumerate() {
        if ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u' {
            return Some(i);
        }
    }
    None
}

fn first_qu(input: &str) -> Option<usize> {
    input.find("qu")
}

fn all_y(input: &str) -> Vec<usize> {
    let mut output: Vec<usize> = Vec::new();
    for (i, ch) in input.chars().enumerate() {
        if ch == 'y' { output.push(i); }
    }
    output
}