use std::sync::LazyLock;
use std::collections::HashMap;

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    InvalidRowCount(usize),
    InvalidColumnCount(usize),
}

static MAP: LazyLock<HashMap<Vec<&str>, &str>> = LazyLock::new(|| {
    HashMap::from([
        (vec![" _ ", "| |", "|_|", "   "], "0"), (vec!["   ", "  |", "  |", "   "], "1"), 
        (vec![" _ ", " _|", "|_ ", "   "], "2"), (vec![" _ ", " _|", " _|", "   "], "3"), 
        (vec!["   ", "|_|", "  |", "   "], "4"), (vec![" _ ", "|_ ", " _|", "   "], "5"),
        (vec![" _ ", "|_ ", "|_|", "   "], "6"), (vec![" _ ", "  |", "  |", "   "], "7"), 
        (vec![" _ ", "|_|", "|_|", "   "], "8"), (vec![" _ ", "|_|", " _|", "   "], "9"), 
    ])
});

pub fn convert(input: &str) -> Result<String, Error> {
    let row_count = input.lines().count();
    if !row_count.is_multiple_of(4) { return Err(Error::InvalidRowCount(row_count)); }

    let col_count = input.lines().next().unwrap().len();
    if !col_count.is_multiple_of(3) { return Err(Error::InvalidColumnCount(col_count)); }

    let lines: Vec<_> = input.lines().collect();
    Ok(lines.chunks(4)
        .map(|group| {
            let mut row_group = group.to_vec();
            let mut digits = String::new();
            let mut flag = true;

            while flag {
                let mut current: Vec<&str> = Vec::new();
                let mut next: Vec<&str> = Vec::new();
                
                for row in row_group {
                    let (take, rest) = row.split_at(3);
                    if rest.len() == 0 { flag = false; }
                    current.push(take);
                    next.push(rest);
                }

                digits.push_str(MAP.get(&current).copied().unwrap_or("?"));
                row_group = next;
            }
            
            digits
        })
        .collect::<Vec<_>>()
        .join(","))
}
