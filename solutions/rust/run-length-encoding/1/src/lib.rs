pub fn encode(source: &str) -> String {
    if source.is_empty() { return String::new(); }

    let mut result = String::from("");
    let mut count = 1;
    let len = source.len();
    for (i, w) in source.chars().collect::<Vec<char>>().windows(2).enumerate() {
        if w[0] == w[1] {
            count += 1;
        } else {
            if count == 1 {
                result.push(w[0]);
            } else {
                result.push_str(&count.to_string());
                result.push(w[0]);
                count = 1;
            }
        }

        if i == len - 2 {
            if w[0] == w[1] {
                result.push_str(&count.to_string());
                result.push(w[0]);
            } else {
                result.push(w[1]);
            }
        }
    }
    
    result
}

pub fn decode(source: &str) -> String {
    if source.is_empty() { return String::new(); }

    let mut result = String::new();
    let mut num = String::from("0");
    for ch in source.chars() {
        if ch.is_numeric() {
            num.push(ch);
        } else {
            let n: usize = num.parse().unwrap();
            if n == 0 {
                result.push(ch);
            } else {
                result.push_str(&ch.to_string().repeat(n));
                num = String::from("0");
            }
        }
    }

    result
}
