#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist(first_list: &[i32], second_list: &[i32]) -> Comparison {
    match (is_sublist(first_list, second_list), is_sublist(second_list, first_list)) {
        (true, true) => Comparison::Equal,
        (true, false) => Comparison::Sublist,
        (false, true) => Comparison::Superlist,
        (false, false) => Comparison::Unequal,
    }
}

fn is_sublist(first: &[i32], second: &[i32]) -> bool {
    if first == &[] {return true;}
    second.windows(first.len()).any(|window| window == first)
}