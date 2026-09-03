use std::collections::HashSet;

pub fn sum_of_multiples(limit: u32, factors: &[u32]) -> u32 {
    let mut multiples: HashSet<u32> = HashSet::new();
    for &n in factors {
        if n == 0 { continue; }
        
        let mut times = 1;
        while (n * times < limit) {
            multiples.insert(n * times);
            times += 1;
        }
    }

    multiples.iter().fold(0, |acc, n| acc + n)
}
