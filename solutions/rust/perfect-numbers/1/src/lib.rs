#[derive(Debug, PartialEq, Eq)]
pub enum Classification {
    Abundant,
    Perfect,
    Deficient,
}

pub fn classify(num: u64) -> Option<Classification> {
    if num < 1 { return None; }
    match (1..num).filter(|&n| num.is_multiple_of(n)).sum::<u64>() {
        n if n == num => Some(Classification::Perfect),
        n if n > num => Some(Classification::Abundant),
        n if n < num => Some(Classification::Deficient),
        _ => None,
    }
}
