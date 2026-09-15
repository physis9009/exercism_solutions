use std::collections::HashMap;

static NUCS: &str = "ACGT";

pub fn count(nucleotide: char, dna: &str) -> Result<usize, char> {
    if !NUCS.contains(nucleotide) { return Err(nucleotide); }
    
    let mut num = 0;
    for ch in dna.chars() {
        if !NUCS.contains(ch) { return Err(ch); }
        if ch == nucleotide { num += 1; }
    }
    Ok(num)
}

pub fn nucleotide_counts(dna: &str) -> Result<HashMap<char, usize>, char> {
    let mut result: HashMap<char, usize> = NUCS.chars().map(|c| (c, 0)).collect();
    for ch in dna.chars() {
        if !NUCS.contains(ch) { return Err(ch); }
        let count = match result.get(&ch) {
            None => 0,
            Some(&n) => n,
        };
        
        result.insert(ch, count + 1);
    }

    Ok(result)
}
