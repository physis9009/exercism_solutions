import gleam/int
import gleam/list
import gleam/string

pub fn is_armstrong_number(number: Int) -> Bool {
  let digits_list = int.to_string(number) |> string.to_graphemes |> list.map(fn(item) {
    let assert Ok(digit) = int.parse(item)
    digit
  })
  list.fold(digits_list, 0, fn(acc, item) {
    int_power(item, list.length(digits_list)) + acc
  }) == number
}

fn int_power(base: Int, exponent: Int) -> Int {
  case exponent {
    0 -> 1
    _ -> base * int_power(base, exponent - 1)
  }
}