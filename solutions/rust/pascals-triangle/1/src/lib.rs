pub struct PascalsTriangle(Vec<Vec<u32>>);

impl PascalsTriangle {
    pub fn new(row_count: u32) -> Self {
        let mut rows: Vec<Vec<u32>> = Vec::with_capacity(row_count as usize);
        for _ in 0..row_count {
            let mut row: Vec<u32>;
            match rows.last() {
                None => row = vec![1],
                Some(prev) => {
                    row = vec![0];
                    let mut prev_clone = prev.clone();
                    row.append(&mut prev_clone);
                    row.push(0);
                    row = row.windows(2).map(|pair| pair[0] + pair[1]).collect();
                }
            }
            
            rows.push(row);
        }

        PascalsTriangle(rows)
    }

    pub fn rows(&self) -> Vec<Vec<u32>> {
        self.0.clone()
    }
}
