pub fn number(user_number: &str) -> Option<String> {
    let digits_vec: Vec<char> = user_number
        .chars()
        .filter(|ch| ch.is_ascii_digit())
        .collect();
    
    match digits_vec.len() {
        10 => {
            match (
                ('2'..='9').any(|ch| ch == digits_vec[0]), 
                ('2'..='9').any(|ch| ch == digits_vec[3])
            ) {
                (true, true) => Some(digits_vec.into_iter().collect::<String>()),
                _ => None,
            }
        }
        11 => {
            if digits_vec[0] != '1' { return None; }
            match (
                ('2'..='9').any(|ch| ch == digits_vec[1]), 
                ('2'..='9').any(|ch| ch == digits_vec[4])
            ) {
                (true, true) => Some(digits_vec.into_iter().skip(1).collect::<String>()),
                _ => None,
            }
        }
        _ => None,
    }
    
}
