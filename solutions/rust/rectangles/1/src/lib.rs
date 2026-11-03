use std::collections::HashSet;

pub fn count(lines: &[&str]) -> u32 {
    let row_count = lines.len();
    if row_count == 0 { return 0; }
    let col_count = lines[0].len();
    if col_count == 0 { return 0; }

    let mut r = 0;
    let mut c = 0;
    let mut horizontal: Vec<((usize, usize), (usize, usize))> = Vec::new();
    let mut vertical: Vec<((usize, usize), (usize, usize))> = Vec::new();
    for row in lines {
        for ch in row.chars() {
            if ch != '+' { 
                c += 1;
                continue; 
            }

            let mut c_end = c + 1;
            while c_end < col_count {
                let end = lines[r].chars().nth(c_end).unwrap();
                if end != '+' && end != '-' { break; }
                if end == '-' {
                    c_end += 1;
                    continue;
                }
                horizontal.push(((r, c), (r, c_end)));
                c_end += 1;
            }

            let mut r_end = r + 1;
            while r_end < row_count {
                let end = lines[r_end].chars().nth(c).unwrap();
                if end != '+' && end != '|' { break; }
                if end == '|' {
                    r_end += 1;
                    continue;
                }
                vertical.push(((r, c), (r_end, c)));
                r_end += 1;
            }
            
            c += 1;
        }
        r += 1;
        c = 0;
    }

    let mut used: HashSet<((usize, usize), (usize, usize))> = HashSet::new();
    let mut candidates: Vec<(((usize, usize), (usize, usize)), ((usize, usize), (usize, usize)))> = Vec::new();
    for &((r_start_upper, c_start_upper), (r_end_upper, c_end_upper)) in &horizontal {
        used.insert(((r_start_upper, c_start_upper), (r_end_upper, c_end_upper)));
        for &((r_start_lower, c_start_lower), (r_end_lower, c_end_lower)) in &horizontal {
            if used.contains(&((r_start_lower, c_start_lower), (r_end_lower, c_end_lower))) {
                continue;
            }

            if c_start_upper == c_start_lower && c_end_upper == c_end_lower {
                candidates.push((((r_start_upper, c_start_upper), (r_start_lower, c_start_lower)), ((r_end_upper, c_end_upper), (r_end_lower, c_end_lower))));
            }
        }
    }

    let mut count = 0;
    for (((r_start_upper, c_start_upper), (r_start_lower, c_start_lower)), ((r_end_upper, c_end_upper), (r_end_lower, c_end_lower))) in candidates {
        if vertical.iter().any(|&((a1, a2), (b1, b2))| r_start_upper == a1 && c_start_upper == a2 && r_start_lower == b1 && c_start_lower == b2) && vertical.iter().any(|&((a1, a2), (b1, b2))| r_end_upper == a1 && c_end_upper == a2 && r_end_lower == b1 && c_end_lower == b2) { count += 1; }
    }

    count
}
