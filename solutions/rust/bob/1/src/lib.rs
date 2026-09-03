pub fn reply(message: &str) -> &str {
    let trimmed = message.trim();
    
    let alphabets: String = message.chars()
        .filter(|c| c.is_alphabetic())
        .collect();
    
    let ends_with_q_mark = trimmed.ends_with("?");
    let all_uppercase = alphabets.chars().all(|c| c.is_uppercase());
    let is_nothing = message.is_empty() || trimmed.is_empty();
    let has_alphabets = !alphabets.is_empty();
    
    match (ends_with_q_mark, all_uppercase, is_nothing, has_alphabets) {
        (false, _, true, _) => "Fine. Be that way!",
        (true, true, false, true) => "Calm down, I know what I'm doing!",
        (false, true, false, true) => "Whoa, chill out!",
        (true, _, false, _) => "Sure.",
        (_, _, _, _) => "Whatever.",
    }
}
