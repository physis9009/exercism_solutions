use std::fmt::{Display, Formatter, Result};

static ROMAN_NUM: [char; 7] = ['I', 'V', 'X', 'L', 'C', 'D', 'M'];

pub struct Roman(String);

impl Display for Roman {
    fn fmt(&self, f: &mut Formatter<'_>) -> Result {
        f.write_str(self.0.as_str())
    }
}

impl From<u32> for Roman {
    fn from(num: u32) -> Self {
        let mut digits: Vec<String> = Vec::new();
        let mut n = num;
        let mut coef = 0;
        while n != 0 {
            let r = n % 10;
            let s = match r {
                0 => String::new(),
                1..=3 => ROMAN_NUM[(coef * 2) as usize].to_string().repeat(r as usize),
                4 => format!("{}{}", ROMAN_NUM[(coef * 2) as usize], ROMAN_NUM[(coef * 2 + 1) as usize]),
                5 => ROMAN_NUM[(coef * 2 + 1) as usize].to_string(),
                6..=8 => format!("{}{}", ROMAN_NUM[(coef * 2 + 1) as usize], ROMAN_NUM[(coef * 2) as usize].to_string().repeat((r - 5) as usize)),
                _ => format!("{}{}", ROMAN_NUM[(coef * 2) as usize], ROMAN_NUM[(coef * 2 + 2) as usize]),
            };
            digits.push(s);
            coef += 1;
            n /= 10;
        }
        
        Roman(digits.into_iter().rev().collect())
    }
}
