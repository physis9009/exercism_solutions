enum Square {
    Flower,
    Empty { count: u8 },
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
    
    for row in garden.iter() {
        let mut squares_row: Vec<Square> = Vec::new();
        for &square in row.as_bytes() {
            match square {
                b'*' => squares_row.push(Square::Flower),
                b' ' => squares_row.push(Square::Empty { count: 0 }),
                _ => panic!("Invalid character: {}", square as char),
            }
        }
        fulfilled.push(squares_row);
    }

    for r in 0..fulfilled.len() {
        for c in 0..fulfilled[r].len() {
            if matches!(fulfilled[r][c], Square::Empty { .. }) {
                let flower_count = count_flowers(&fulfilled, r, c);
                if let Square::Empty { count, .. } = &mut fulfilled[r][c] {
                    *count = flower_count;
                }
            }
        }
    }
    
    fulfilled
}

fn count_flowers(fulfilled: &[Vec<Square>], row: usize, col: usize) -> u8 {
    let mut count = 0;
    let rows = fulfilled.len() as i32;
    let cols = fulfilled[row].len() as i32;

    for dr in -1..=1 {
        for dc in -1..=1 {
            if dr == 0 && dc == 0 {
                continue;
            }
            
            let nr = row as i32 + dr;
            let nc = col as i32 + dc;
            
            if nr >= 0 && nr < rows && nc >= 0 && nc < cols
                && let Square::Flower = fulfilled[nr as usize][nc as usize]
            {
                count += 1;
            }
        }
    }

    count
}

fn to_strings(fulfilled: &[Vec<Square>]) -> Vec<String> {
    let mut result: Vec<String> = Vec::new();

    for row in fulfilled {
        let mut str_row = String::new();
        for square in row {
            match square {
                Square::Flower => str_row.push('*'),
                Square::Empty { count } => {
                    if *count == 0 {
                        str_row.push(' ');
                    } else {
                        let char_count = char::from_digit(*count as u32, 10)
                            .expect("Should be 0-9");
                        str_row.push(char_count);
                    }
                }
            }
        }
        result.push(str_row);
    }

    result
}