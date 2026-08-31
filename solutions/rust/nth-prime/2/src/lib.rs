pub fn nth(n: u32) -> u32 {
    let mut cur = 0;
    let mut result = 2;
    while cur <= n {
        if !is_prime(result) {
            result = next(result);
        } else if cur == n {
            return result;
        } else {
            result = next(result);
            cur += 1;
        }
    }

    result
}

fn is_prime(num: u32) -> bool {
    if num <= 1 {return false;}
    
    let sqrt = num.isqrt();
    let mut n = 2;
    while n <= sqrt {
        if num.is_multiple_of(n) {return false;}

        if n == 2 {n += 1;} else {n += 2;}
    }

    true
}

fn next(num: u32) -> u32 {
    if num == 2 {return num + 1;}
    num + 2
}