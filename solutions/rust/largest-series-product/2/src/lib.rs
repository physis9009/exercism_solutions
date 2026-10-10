#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    SpanTooLong,
    InvalidDigit(char),
}

pub fn lsp(string_digits: &str, span: usize) -> Result<u64, Error> {
    if span > string_digits.len() { return Err(Error::SpanTooLong); }
    if span == 0 { return Ok(1); }
    
    let digits: Vec<u64> = string_digits
        .chars()
        .map(|ch| ch.to_digit(10).map(|n| n as u64).ok_or(Error::InvalidDigit(ch)))
        .collect::<Result<Vec<u64>, Error>>()?; 

    Ok(digits
        .windows(span)
        .map(|w| w.iter().product())
        .max()
        .unwrap()) 
}
