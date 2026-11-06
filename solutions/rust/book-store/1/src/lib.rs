use std::collections::HashMap;

pub fn lowest_price(books: &[u32]) -> u32 {
    let mut remain = [0_u32; 5];
    for &b in books {
        remain[b as usize - 1] += 1;
    }
    
    let mut memo: HashMap<[u32; 5], u32> = HashMap::new();

    fn dp(rest: [u32; 5], memo: &mut HashMap<[u32; 5], u32>) -> u32 {
        if rest == [0; 5] { return 0; }
        if let Some(&v) = memo.get(&rest) { return v; }
        let mut best = u32::MAX;

        for group in 0b00001..=0b11111 {
            let mut ok = true;
            let mut cnt = 0_u32;

            for i in 0..5 {
                let take = (group >> i) & 1;
                if take > rest[i] {
                    ok = false;
                    break;
                }
                cnt += take;
            }
            if !ok { continue; }

            let mut next = rest;
            for i in 0..5 {
                next[i] -= (group >> i) & 1;
            }

            let cand = group_value(cnt as usize) + dp(next, memo);
            best = best.min(cand);
        }

        memo.insert(rest, best);
        best
    }

    dp(remain, &mut memo)
}

fn group_value(count: usize) -> u32 {
    match count {
        1 => 800,
        2 => 1520,
        3 => 2160,
        4 => 2560,
        5 => 3000,
        _ => unreachable!(),
    }
}
