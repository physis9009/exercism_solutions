pub fn is_valid_isbn(isbn: &str) -> bool {
    if isbn.len() < 10 { return false; }
    
    let (first9, last1) = isbn.split_at(isbn.len() - 1);
    match (
        first9.chars().filter(|&ch| ch != '-').count(),
        first9.chars().filter(|&ch| ch != '-').all(|ch| ch.is_ascii_digit()),
        last1.chars().all(|ch| ch.is_ascii_digit() || ch == 'X')
    ) {
        (9, true, true) => {
            let sum_first9: u32 = first9
                .chars()
                .filter(|&ch| ch != '-')
                .map(|ch| ch.to_digit(10).unwrap())
                .zip((2..=10_u32).rev())
                .map(|(x, y)| x * y)
                .sum();
            let num_last1 = last1.chars().next().unwrap();
            let val_last1 = if num_last1 == 'X' {
                10
            } else { num_last1.to_digit(10).unwrap() };

            (sum_first9 + val_last1).is_multiple_of(11)
        }
        
        (_, _, _) => false,
    }
}
