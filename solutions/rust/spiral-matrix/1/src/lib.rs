pub fn spiral_matrix(size: u32) -> Vec<Vec<u32>> {
    let n = size as usize;
    let mut result = vec![vec![0_u32; n]; n];
    if n == 0 { return result; }

    let (mut top, mut bottom) = (0_i32, n as i32 - 1);
    let (mut left, mut right) = (0_i32, n as i32 - 1);
    let mut val = 1u32;

    while top <= bottom && left <= right {
        for c in left..=right {
            result[top as usize][c as usize] = val;
            val += 1;
        }
        top += 1;

        for r in top..=bottom {
            result[r as usize][right as usize] = val;
            val += 1;
        }
        right -= 1;

        if top <= bottom {
            for c in (left..=right).rev() {
                result[bottom as usize][c as usize] = val;
                val += 1;
            }
            bottom -= 1;
        }

        if left <= right {
            for r in (top..=bottom).rev() {
                result[r as usize][left as usize] = val;
                val += 1;
            }
            left += 1;
        }
    }

    result
}
