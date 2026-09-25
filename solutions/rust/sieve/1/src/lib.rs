pub fn primes_up_to(upper_bound: u64) -> Vec<u64> {
    let mut result: Vec<u64> = (2..=upper_bound).collect();
    let mut i = 0;
    while i < result.len() {
        let cur = result[i];          
        result = result
            .into_iter()
            .filter(|&n| n == cur || !n.is_multiple_of(cur))
            .collect();
        i += 1;
    }
    
    result
}
