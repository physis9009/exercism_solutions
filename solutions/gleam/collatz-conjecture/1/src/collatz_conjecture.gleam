import gleam/int

pub type Error {
  NonPositiveNumber
}

pub fn steps(number: Int) -> Result(Int, Error) {
  case number {
    n if n <= 0 -> Error(NonPositiveNumber)
    1 -> Ok(0)
    _ -> Ok(cc_loop(number, 0))
  }
}

fn cc_loop(number: Int, acc: Int) -> Int {
  case int.is_even(number) {
    True -> cc_loop(number / 2, acc + 1)
    False -> case number {
      1 -> acc
      _ -> cc_loop(number * 3 + 1, acc + 1)
    }
  }
}