pub fn factors(mut n: u64) -> Vec<u64> {
    let mut results = Vec::new();
    let mut factor = 2;
    
    while factor * factor <= n {
        while n.is_multiple_of(factor) {
            results.push(factor);
            n /= factor;
        }
        factor = next_prime(factor);
    }
    
    if n > 1 {
        results.push(n);
    }
    
    results
}

fn is_prime(num: u64) -> bool {
    if num <= 1 {return false;}
    let sqrt = num.isqrt();
    let mut n = 2;
    while n <= sqrt {
        if num.is_multiple_of(n) {return false;}
        n = next(n);
    }
    true
}

fn next(num: u64) -> u64 {
    let mut n = num;
    if n == 2 {n += 1;} else {n += 2;}
    n
}

fn next_prime(num: u64) -> u64 {
    let mut n = next(num);
    loop {
        if is_prime(n) {return n;}
        n = next(n);
    }
}