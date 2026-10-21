pub struct Matrix {
    rows: usize,
    cols: usize,
    literal: String,
}

impl Matrix {
    pub fn new(input: &str) -> Self {
        let rows = input.lines().count();
        let cols = input.lines().next().unwrap().split(' ').count();
        Self {rows, cols, literal: input.to_string()}
    }

    pub fn row(&self, row_no: usize) -> Option<Vec<u32>> {
        if row_no > self.rows { return None; }

        let row_literal = self.literal.lines().nth(row_no - 1)?;
        Some(
            row_literal
                .split(' ')
                .map(|num| num.parse().unwrap())
                .collect()
        )
    }

    pub fn column(&self, col_no: usize) -> Option<Vec<u32>> {
        if col_no > self.cols { return None; }

        Some(
            self.literal
                .lines()
                .map(|line| line.split(' ').map(|num| num.parse().unwrap()).nth(col_no - 1).unwrap())
                .collect()
        )
    }
}
