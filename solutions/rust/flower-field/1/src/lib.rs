struct Position {
    row: u8,
    col: u8,
}

enum Square {
    Flower {
        position: Position,
    },
    Empty {
        position: Position,
        count: u8,
    }
}

pub fn annotate(garden: &[&str]) -> Vec<String> {
    if garden.is_empty() {
        return Vec::new();
    }

    let fulfilled = fulfill(garden);
    to_strings(&fulfilled)
}

fn fulfill(garden: &[&str]) -> Vec<Vec<Square>> {
    let mut fulfilled: Vec<Vec<Square>> = Vec::new();
    
    for (row_num, row) in garden.iter().enumerate() {
        let mut squares_row: Vec<Square> = Vec::new();
        for (col_num, square) in row.as_bytes().iter().enumerate() {
            let pos = Position {
                row: row_num as u8,
                col: col_num as u8,
            };
            match *square {
                42 => squares_row.push(Square::Flower {position: pos}),
                32 => squares_row.push(Square::Empty {position: pos, count: 0}),
                _ => panic!("Invalid character: {}", *square),
            }
        }
        fulfilled.push(squares_row);
    }

    for r in 0..fulfilled.len() {
        for c in 0..fulfilled[0].len() {
            if let Square::Empty {count, ..} = fulfilled[r][c] {
                let flower_count = count_flowers(&fulfilled, r, c);
            
                if let Square::Empty {count, ..} = &mut fulfilled[r][c] {
                    *count = flower_count;
                }
            }
        }
    }
    
    fulfilled
}

fn count_flowers(fulfilled: &Vec<Vec<Square>>, row: usize, col: usize) -> u8 {
    let mut count = 0;
    let rows = fulfilled.len() as i32;
    let cols = fulfilled[0].len() as i32;

    for offset_row in -1..=1 {
        for offset_col in -1..=1 {
            if offset_row == 0 && offset_col == 0 {continue;}
            let row_num = row as i32 + offset_row;
            let col_num = col as i32 + offset_col;
            if row_num >= 0 && row_num < rows && col_num < cols && col_num >= 0 {
                if let Square::Flower {..} = fulfilled[row_num as usize][col_num as usize] {
                    count += 1;
                }
            }
        }
    }

    count
}

fn to_strings(fulfilled: &Vec<Vec<Square>>) -> Vec<String> {
    let mut result: Vec<String> = Vec::new();

    for row in fulfilled {
        let mut str_row = String::new();
        for square in row {
            match square {
                Square::Flower {..} => str_row.push('*'),
                Square::Empty {count, ..} => {
                    if *count == 0 {
                        str_row.push(' ');
                    } else {
                        let char_count = char::from_digit(*count as u32, 10).expect("Should be 0-9");
                        str_row.push(char_count);
                    }
                }
            }
        }

        result.push(str_row);
    }

    result
}