import gleam/list
import gleam/result
import gleam/int

pub type Error {
  InvalidBase(Int)
  InvalidDigit(Int)
}

pub fn rebase(
  digits digits: List(Int),
  input_base input_base: Int,
  output_base output_base: Int,
) -> Result(List(Int), Error) {
  use powers_list <- result.try(powers(input_base, list.length(digits), [1]))
  use base10_list <- result.try(base10(powers_list, digits, input_base))
  output(int.sum(base10_list), output_base, [])
}

fn powers(base: Int, length: Int, acc: List(Int)) -> Result(List(Int), Error) {
  case base, length {
    b, _ if b < 2 -> Error(InvalidBase(b))
    b, l if l > 1 -> {
      let assert Ok(prev_digit) = list.first(acc)
      powers(b, l - 1, [prev_digit * b, ..acc])
    }
    _, _ -> Ok(acc)
  }
}

fn base10(powers_list: List(Int), digits: List(Int), base: Int) -> Result(List(Int), Error) {
  case list.find(digits, fn(digit) {digit < 0 || digit >= base}) {
    Ok(digit) -> Error(InvalidDigit(digit))
    Error(_) -> Ok(list.map2(powers_list, digits, fn(x, y) {x * y}))
  }
}

fn output(value: Int, base: Int, acc: List(Int)) -> Result(List(Int), Error) {
  case base > 1 {
    False -> Error(InvalidBase(base))
    True -> case value / base, value % base {
      q, r if q != 0 -> output(q, base, [r, ..acc])
      _, r -> Ok([r, ..acc])
    }
  }
}