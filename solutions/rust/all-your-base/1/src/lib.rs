#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit(u32),
}

pub fn convert(number: &[u32], from_base: u32, to_base: u32) -> Result<Vec<u32>, Error> {
    if from_base <= 1 { return Err(Error::InvalidInputBase); }
    if to_base <= 1 { return Err(Error::InvalidOutputBase); }
    
    if number.is_empty() { return Ok(vec![0]); }
    
    for &n in number {
        if n >= from_base { return Err(Error::InvalidDigit(n)); }
    }
    
    if number.iter().all(|&n| n == 0) { return Ok(vec![0]); }
    
    let mut decimal: u64 = 0;
    let from_base = from_base as u64;
    for &n in number {
        decimal = decimal * from_base + n as u64;
    }
    
    let to_base = to_base as u64;
    let mut result = Vec::new();
    let mut temp = decimal;
    
    while temp > 0 {
        result.push((temp % to_base) as u32);
        temp /= to_base;
    }
    
    result.reverse();
    Ok(result)
}