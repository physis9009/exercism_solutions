pub fn abbreviate(phrase: &str) -> String {
    phrase
        .split(|c| c == ' ' || c == '-')
        .filter(|word| !word.is_empty())
        .map(|word| {
            let processed: String = word
                .chars()
                .filter(|c| c.is_alphabetic())
                .collect();
            
            match processed.chars().all(|c| c.is_ascii_uppercase()) {
                true => processed
                    .chars()
                    .next()
                    .unwrap()
                    .to_ascii_uppercase()
                    .to_string(),
                false => {
                    let upper: String = processed
                        .chars()
                        .filter(|c| c.is_ascii_uppercase())
                        .collect();
                    
                    if upper.is_empty() { processed
                                          .chars()
                                          .next()
                                          .unwrap()
                                          .to_ascii_uppercase()
                                          .to_string() } else { upper }
                }
            }
        }
    )
    .collect::<String>()
}