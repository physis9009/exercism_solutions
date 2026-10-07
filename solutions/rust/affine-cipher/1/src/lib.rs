#[derive(Debug, Eq, PartialEq)]
pub enum AffineCipherError {
    NotCoprime(u32),
}

pub fn encode(plaintext: &str, a: u32, b: u32) -> Result<String, AffineCipherError> {
    if !are_coprime(a, 26) { return Err(AffineCipherError::NotCoprime(a)); }
    let result = plaintext.chars()
        .filter_map(|ch| {
            match (ch.is_ascii_alphabetic(), ch.is_ascii_digit()) {
                (true, _) => {
                    let i = ch.to_ascii_lowercase() as u32 - 97;
                    Some(char::from_u32((a * i + b) % 26 + 97).unwrap())
                }
                (_, true) => Some(ch),
                (_, _) => None,
            }
        })
        .enumerate()
        .flat_map(|(i, c)| {
            if i > 0 && i.is_multiple_of(5) {
                vec![' ', c]
            } else { vec![c] }
        })
        .collect::<String>();
    
    Ok(result)
}

pub fn decode(ciphertext: &str, a: u32, b: u32) -> Result<String, AffineCipherError> {
    if !are_coprime(a, 26) { return Err(AffineCipherError::NotCoprime(a)); }
    
    let a_inv = mmi(a, 26).unwrap();
    let result = ciphertext.chars()
        .filter_map(|ch| {
            match (ch.is_ascii_alphabetic(), ch.is_ascii_digit()) {
                (true, _) => {
                    let y = ch.to_ascii_lowercase() as u32 - 97;
                    Some(char::from_u32((a_inv * (y + 26 - b % 26)) % 26 + 97).unwrap())
                }
                (_, true) => Some(ch),
                (_, _) => None,
            }
        })
        .collect::<String>();
    
    Ok(result)
}

fn are_coprime(a: u32, b: u32) -> bool {
    !(2..=(a.min(b)))
        .any(|n| a.is_multiple_of(n) && b.is_multiple_of(n))
}

fn mmi(a: u32, m: u32) -> Option<u32> {
    (1..m).find(|&x| (a * x) % m == 1)
}