#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    IncompleteNumber,
}

pub fn to_bytes(values: &[u32]) -> Vec<u8> {
    let mut result = Vec::new();
    for &(mut value) in values {
        let lowest = value & 0b1111111;
        let mut current = vec![lowest as u8];
        
        value >>= 7;
        while value != 0 {
            let mut high = value & 0b1111111;
            high |= 0b10000000;
            current.push(high as u8);
            value >>= 7;
        }
        current.reverse();
        result.append(&mut current);
    }

    result
}

pub fn from_bytes(bytes: &[u8]) -> Result<Vec<u32>, Error> {
    let mut result = Vec::new();
    let len = bytes.len();
    let mut index = 0;
    
    while index < len {
        let start = index;
        while index < len && bytes[index] & 0b1000_0000 != 0 {
            index += 1;
        }
        
        if index >= len {
            return Err(Error::IncompleteNumber);
        }
        index += 1; 

        let mut value: u32 = 0;
        for &byte in &bytes[start..index] {
            value = (value << 7) | ((byte & 0b01111111) as u32);
        }
        result.push(value);
    }
    
    Ok(result)
}
