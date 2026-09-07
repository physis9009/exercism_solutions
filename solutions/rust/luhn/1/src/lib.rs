pub fn is_valid(code: &str) -> bool {
    if code.chars().any(|c| !c.is_whitespace() && !c.is_ascii_digit()) {
        return false;
    }
    
    let digits: Vec<u32> = code
        .chars()
        .filter(|c| c.is_numeric())
        .map(|c| c.to_digit(10).unwrap())
        .collect();
    
    if digits.len() <= 1 {
        return false;
    }

    digits
        .into_iter()
        .rev()
        .enumerate()
        .map(|(i, n)| {
            if !i.is_multiple_of(2) { 
                let doubled = n * 2;
                if doubled > 9 { doubled - 9 } else { doubled }
            } else {
                n
            }
        })
        .sum::<u32>()
        .is_multiple_of(10)
}