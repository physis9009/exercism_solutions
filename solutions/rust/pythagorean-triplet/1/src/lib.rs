use std::collections::HashSet;

pub fn find(sum: u32) -> HashSet<[u32; 3]> {
    if !sum.is_multiple_of(2) { return HashSet::new(); }

    let mut result: HashSet<[u32; 3]> = HashSet::new();
    let lowbound_a = ((4 * sum + 1).isqrt() - 1) / 2;
    let upbound_a = sum / 3;

    for a in lowbound_a..=upbound_a {
        let num_b = sum * (sum - 2 * a);
        let den_b = 2 * (sum - a);
        if !num_b.is_multiple_of(den_b) { continue; }

        let b = num_b / den_b;
        let c = sum - a - b;
        if a >= b || b >= c { continue; }

        result.insert([a, b, c]);
    }

    result
}
