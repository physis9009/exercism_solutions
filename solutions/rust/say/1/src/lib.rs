use std::collections::HashMap;
use std::sync::LazyLock;

static MAP: LazyLock<HashMap<u64, &str>> = LazyLock::new(|| {
    HashMap::from([
        (0, "zero"), (1, "one"), (2, "two"), (3, "three"), (4, "four"), (5, "five"),
        (6, "six"), (7, "seven"), (8, "eight"), (9, "nine"), (10, "ten"),
        (11, "eleven"), (12, "twelve"), (13, "thirteen"), (14, "fourteen"),
        (15, "fifteen"), (16, "sixteen"), (17, "seventeen"), (18, "eighteen"),
        (19, "nineteen"), (20, "twenty"), (30, "thirty"), (40, "forty"),
        (50, "fifty"), (60, "sixty"), (70, "seventy"), (80, "eighty"), (90, "ninety"),
    ])
});

pub fn encode(n: u64) -> String {
    if n == 0 {
        return "zero".to_string();
    }
    let magnitudes = ["", "thousand", "million", "billion",
                      "trillion", "quadrillion", "quintillion"];
    let mut parts: Vec<String> = Vec::new();
    let mut num = n;
    let mut i = 0;
    while num > 0 {
        let chunk = num % 1000;
        if chunk != 0 {
            let words = three_digit(chunk);
            if i == 0 {
                parts.insert(0, words);
            } else {
                parts.insert(0, format!("{} {}", words, magnitudes[i]));
            }
        }
        num /= 1000;
        i += 1;
    }
    parts.join(" ")
}

fn three_digit(n: u64) -> String {
    if n < 20 {
        return MAP[&n].to_string();
    }
    if n < 100 {
        let tens = n / 10 * 10;
        let ones = n % 10;
        if ones == 0 {
            return MAP[&tens].to_string();
        }
        return format!("{}-{}", MAP[&tens], MAP[&ones]);
    }
    let hundreds = n / 100;
    let rest = n % 100;
    if rest == 0 {
        return format!("{} hundred", MAP[&hundreds]);
    }
    format!("{} hundred {}", MAP[&hundreds], three_digit(rest))
}