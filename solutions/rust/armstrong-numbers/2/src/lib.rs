pub fn is_armstrong_number(num: u32) -> bool {
    let digits = digits_of(num);
    let mut result = 0;
    let mut count = digits;
    let mut digit: u32;
    let mut dividend = num;

    while count != 0 {
        digit = dividend / (10_u32.pow(count - 1));
        result += digit.pow(digits);
        dividend -= digit * 10_u32.pow(count - 1);
        count -= 1;
    }

    result == num
}

fn digits_of(mut num: u32) -> u32 {
    let mut digits = 1;

    while num / 10 != 0 {
        num /= 10;
        digits += 1;
    }

    digits
}