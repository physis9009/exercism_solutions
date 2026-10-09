pub fn encrypt(input: &str) -> String {
    let normalized: String = input.chars()
        .filter(|ch| ch.is_ascii_alphanumeric())
        .map(|ch| ch.to_ascii_lowercase())
        .collect();
    let len = normalized.len();
    let (row, col) = factorize(len);
    let padded: Vec<char> = format!("{:<total$}", normalized, total = row * col).chars().collect();
    let mut result = Vec::new();
    for i in 0..col {
        for j in 0..row {
            result.push(padded[j * col + i]);
        }
        result.push(' ');
    }
    result.pop();

    result.into_iter().collect::<String>()
}

fn factorize(len: usize) -> (usize, usize) {
    let col = len.isqrt();
    let col = if col * col == len { col } else { col + 1 }; 
    let row = if col == 0 { 0 } else { (len + col - 1) / col }; 
    (row, col)
}