use std::collections::HashSet;

pub fn collatz(n: u64) -> Option<u64> {
    let mut next_n = n;
    let mut used: HashSet<u64> = HashSet::new();
    let mut steps = 0;

    while !next_n.is_power_of_two() {
        used.insert(next_n);
        
        match next_n.is_multiple_of(2) {
            true => {
                next_n /= 2;
                steps += 1;
            }
            false => {
                next_n = next_n * 3 + 1;
                steps += 1;
            }
        }
        
        if used.contains(&next_n) { return None; }
    }

    Some((steps + next_n.trailing_zeros()) as u64)
}
