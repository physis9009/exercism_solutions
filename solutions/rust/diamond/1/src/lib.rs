pub fn get_diamond(c: char) -> Vec<String> {
    if c == 'A' { return vec![String::from("A")]; }
    
    let index = c as u32 - 65;
    let width = (index * 2 + 1) as usize;
    
    let mut result = Vec::new();
    let head_tail = format!("{:^width$}", 'A');
    result.push(head_tail);

    for i in 1..=index {
        let ch = char::from_u32(i + 65).unwrap();
        let mid = ((i - 1) * 2 + 1) as usize;
        let end = (width - 2 - mid) / 2;
        let line = format!(
            "{}{}{}{}{}",
            " ".repeat(end),
            ch,
            " ".repeat(mid),
            ch,
            " ".repeat(end)
        );
        result.push(line);
    }

    let mut down_half = result.clone();
    down_half.pop();
    down_half.reverse();
    result.append(&mut down_half);

    result
}
