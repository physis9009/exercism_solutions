use std::cmp::Ordering;
use std::ops::{Add, Sub, Mul};

#[derive(Debug)]
pub struct Decimal {
    sign: bool,
    digits: Vec<u8>,
    exp: i32,
}

impl Decimal {
    pub fn try_from(input: &str) -> Option<Decimal> {
        let body = input.trim();
        if body.is_empty() {
            return None;
        }

        let (sign, rest) = match body.as_bytes()[0] {
            b'+' => (false, &body[1..]),
            b'-' => (true, &body[1..]),
            _ => (false, body),
        };

        if rest.is_empty() {
            return None;
        }

        let mut dot_seen = false;
        let mut has_digit = false;
        for ch in rest.chars() {
            match ch {
                '0'..='9' => has_digit = true,
                '.' => {
                    if dot_seen {
                        return None;
                    }
                    dot_seen = true;
                }
                _ => return None,
            }
        }
        if !has_digit {
            return None;
        }

        if let Some(pos) = rest.find('.') {
            if rest[..pos].is_empty() || rest[pos + 1..].is_empty() {
                return None;
            }
        }

        let (int_str, frac_str) = match rest.find('.') {
            Some(pos) => (&rest[..pos], &rest[pos + 1..]),
            None => (rest, ""),
        };

        let int_trimmed = int_str.trim_start_matches('0');
        let frac_trimmed = frac_str.trim_end_matches('0');

        let mut digits: Vec<u8> = Vec::with_capacity(int_trimmed.len() + frac_trimmed.len());
        for ch in int_trimmed.chars().chain(frac_trimmed.chars()) {
            digits.push(ch.to_digit(10).unwrap() as u8);
        }

        if digits.is_empty() || digits.iter().all(|&d| d == 0) {
            return Some(Decimal {
                sign: false,
                digits: vec![0],
                exp: 0,
            });
        }

        let start = {
            let mut s = 0;
            while s + 1 < digits.len() && digits[s] == 0 {
                s += 1;
            }
            s
        };
        let digits = digits[start..].to_vec();

        let exp = -(frac_trimmed.len() as i32);

        Some(Decimal { sign, digits, exp })
    }

    fn trim_leading_zeros(v: &[u8]) -> &[u8] {
        let mut s = 0;
        while s + 1 < v.len() && v[s] == 0 {
            s += 1;
        }
        &v[s..]
    }

    fn cmp_abs(d1: &[u8], d2: &[u8]) -> Ordering {
        let a = Self::trim_leading_zeros(d1);
        let b = Self::trim_leading_zeros(d2);
        match a.len().cmp(&b.len()) {
            Ordering::Equal => {
                for i in 0..a.len() {
                    match a[i].cmp(&b[i]) {
                        Ordering::Equal => continue,
                        ord => return ord,
                    }
                }
                Ordering::Equal
            }
            ord => ord,
        }
    }

    fn align_exp(d1: &[u8], e1: i32, d2: &[u8], e2: i32) -> (Vec<u8>, Vec<u8>, i32) {
        let exp_new = e1.min(e2);
        let pad1 = (e1 - exp_new) as usize;
        let pad2 = (e2 - exp_new) as usize;

        let mut a = d1.to_vec();
        a.extend(std::iter::repeat_n(0u8, pad1));

        let mut b = d2.to_vec();
        b.extend(std::iter::repeat_n(0u8, pad2));

        (a, b, exp_new)
    }

    fn add_digits(a: &[u8], b: &[u8]) -> Vec<u8> {
        let len = a.len().max(b.len());
        let mut av = vec![0u8; len - a.len()];
        av.extend_from_slice(a);
        let mut bv = vec![0u8; len - b.len()];
        bv.extend_from_slice(b);

        let mut out = vec![0u8; len];
        let mut carry = 0u8;
        for i in (0..len).rev() {
            let sum = av[i] + bv[i] + carry;
            out[i] = sum % 10;
            carry = sum / 10;
        }
        if carry > 0 {
            out.insert(0, carry);
        }
        let start = {
            let mut s = 0;
            while s + 1 < out.len() && out[s] == 0 {
                s += 1;
            }
            s
        };
        out[start..].to_vec()
    }

    fn sub_digits(a: &[u8], b: &[u8]) -> Vec<u8> {
        let len = a.len().max(b.len());
        let mut av = vec![0u8; len - a.len()];
        av.extend_from_slice(a);
        let mut bv = vec![0u8; len - b.len()];
        bv.extend_from_slice(b);

        let mut out = vec![0u8; len];
        let mut borrow = 0i16;
        for i in (0..len).rev() {
            let mut diff = av[i] as i16 - bv[i] as i16 - borrow;
            if diff < 0 {
                diff += 10;
                borrow = 1;
            } else {
                borrow = 0;
            }
            out[i] = diff as u8;
        }
        let start = {
            let mut s = 0;
            while s + 1 < out.len() && out[s] == 0 {
                s += 1;
            }
            s
        };
        out[start..].to_vec()
    }

    fn is_zero(&self) -> bool {
        self.digits.iter().all(|&d| d == 0)
    }
}

impl PartialEq for Decimal {
    fn eq(&self, other: &Self) -> bool {
        if self.sign != other.sign {
            return false;
        }
        let (a, b, _) = Self::align_exp(&self.digits, self.exp, &other.digits, other.exp);
        Self::cmp_abs(&a, &b) == Ordering::Equal
    }
}

impl PartialOrd for Decimal {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        if self.sign != other.sign {
            return Some(if self.sign { Ordering::Less } else { Ordering::Greater });
        }
        let (a, b, _) = Self::align_exp(&self.digits, self.exp, &other.digits, other.exp);
        let abs_ord = Self::cmp_abs(&a, &b);
        Some(if self.sign { abs_ord.reverse() } else { abs_ord })
    }
}

impl Add for Decimal {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        let (a, b, exp_new) = Self::align_exp(&self.digits, self.exp, &rhs.digits, rhs.exp);

        if self.sign == rhs.sign {
            let digits = Self::add_digits(&a, &b);
            if digits.iter().all(|&d| d == 0) {
                Self { sign: false, digits: vec![0], exp: 0 }
            } else {
                Self { sign: self.sign, digits, exp: exp_new }
            }
        } else {
            match Self::cmp_abs(&a, &b) {
                Ordering::Equal => Self { sign: false, digits: vec![0], exp: 0 },
                Ordering::Greater => Self {
                    sign: self.sign,
                    digits: Self::sub_digits(&a, &b),
                    exp: exp_new,
                },
                Ordering::Less => Self {
                    sign: rhs.sign,
                    digits: Self::sub_digits(&b, &a),
                    exp: exp_new,
                },
            }
        }
    }
}

impl Sub for Decimal {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        if rhs.is_zero() {
            return self;
        }
        self + Self { sign: !rhs.sign, ..rhs }
    }
}

impl Mul for Decimal {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self::Output {
        if self.is_zero() || rhs.is_zero() {
            return Self { sign: false, digits: vec![0], exp: 0 };
        }

        let mut out = vec![0u16; self.digits.len() + rhs.digits.len()];

        for (i, &da) in self.digits.iter().rev().enumerate() {
            if da == 0 { continue; }
            let mut carry = 0u16;
            for (j, &db) in rhs.digits.iter().rev().enumerate() {
                let idx = out.len() - 1 - i - j;
                let cur = out[idx] + (da as u16) * (db as u16) + carry;
                out[idx] = cur % 10;
                carry = cur / 10;
            }
            let mut idx = out.len() - 1 - i - rhs.digits.len();
            while carry > 0 {
                let cur = out[idx] + carry;
                out[idx] = cur % 10;
                carry = cur / 10;
                if idx == 0 { break; }
                idx -= 1;
            }
        }

        let start = {
            let mut s = 0;
            while s + 1 < out.len() && out[s] == 0 {
                s += 1;
            }
            s
        };
        let digits: Vec<u8> = out[start..].iter().map(|&d| d as u8).collect();

        let mut digits = digits;
        let mut exp = self.exp + rhs.exp;
        while digits.len() > 1 && *digits.last().unwrap() == 0 {
            digits.pop();
            exp += 1;
        }

        Self { sign: self.sign ^ rhs.sign, digits, exp }
    }
}