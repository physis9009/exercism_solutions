struct Tree {
    height: u64,
    coordinate: (usize, usize),
}

pub fn find_saddle_points(input: &[Vec<u64>]) -> Vec<(usize, usize)> {
    let num_rows = input.len();
    let num_cols = input[0].len();

    let mut tall_in_row: Vec<Vec<Tree>> = Vec::with_capacity(num_rows);
    let mut short_in_col: Vec<Vec<Tree>> = Vec::with_capacity(num_cols);
    for i in 0..num_rows {
        for j in 0..num_cols {
            update(&mut tall_in_row, input[i][j], i, j, 0);
            update(&mut short_in_col, input[i][j], i, j, 1);
        }
    }

    let candidates_in_row: Vec<(usize, usize)> = tall_in_row
        .into_iter()
        .flatten()
        .map(|tree| tree.coordinate)
        .collect();
    let candidates_in_col: Vec<(usize, usize)> = short_in_col
        .into_iter()
        .flatten()
        .map(|tree| tree.coordinate)
        .collect();

    candidates_in_row
        .iter()
        .filter(|t| candidates_in_col.contains(t))
        .copied()
        .collect::<Vec<(usize, usize)>>()
}

fn update(candidates: &mut Vec<Vec<Tree>>, val: u64, row: usize, col: usize, flag: u8) {
    let index = if flag == 0 { row } else { col };
    if candidates.len() <= index {
        candidates.resize_with(index + 1, Vec::new);
    }
    
    if let Some(prev) = candidates[index].last() {
        match flag {
            0 => {
                if prev.height < val {
                    candidates[index] = vec![Tree {height: val, coordinate: (row, col)}];
                } else if prev.height == val {
                    candidates[index].push(Tree {height: val, coordinate: (row, col)});
                }
            }
            _ => {
                if prev.height > val {
                    candidates[index] = vec![Tree {height: val, coordinate: (row, col)}];
                } else if prev.height == val {
                    candidates[index].push(Tree {height: val, coordinate: (row, col)});
                }
            }
        }
    } else {
        candidates[index] = vec![Tree {height: val, coordinate: (row, col)}];
    }
}