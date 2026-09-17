use std::collections::HashSet;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Palindrome {
    value: u64,
    factors: HashSet<(u64, u64)>,
}

impl Palindrome {
    pub fn value(&self) -> u64 {
        self.value
    }

    pub fn into_factors(self) -> HashSet<(u64, u64)> {
        self.factors
    }
}

pub fn palindrome_products(min: u64, max: u64) -> Option<(Palindrome, Palindrome)> {
    let mut smallest: Option<u64> = None;
    let mut largest: Option<u64> = None;

    for a in min..=max {
        for b in a..=max {        
            let p = a * b;
            if is_pal(p) {
                smallest = Some(smallest.map_or(p, |s| s.min(p)));
                largest  = Some(largest.map_or(p, |l| l.max(p)));
            }
        }
    }

    let (s, l) = (smallest?, largest?);   
    Some((
        Palindrome { value: s, factors: factors_of(s, min, max) },
        Palindrome { value: l, factors: factors_of(l, min, max) },
    ))
}

fn is_pal(num: u64) -> bool {
    let s = num.to_string();
    s == s.chars().rev().collect::<String>()
}

fn factors_of(num: u64, min: u64, max: u64) -> HashSet<(u64, u64)> {
    let mut result = HashSet::new();
    for a in min..=max {
        if a * a > num { break; }       
        if num.is_multiple_of(a) {
            let b = num / a;
            if b >= min && b <= max {
                result.insert((a, b));  
            }
        }
    }
    result
}
