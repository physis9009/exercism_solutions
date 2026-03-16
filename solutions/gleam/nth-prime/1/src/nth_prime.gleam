pub fn prime(number: Int) -> Result(Int, Nil) {
  case number {
    n if n <= 0 -> Error(Nil)
    1 -> Ok(2)
    2 -> Ok(3)
    _ -> Ok(outer_loop(3, number, 5))
  }
}

fn outer_loop(counter: Int, number: Int, value: Int) -> Int {
  case is_prime(value, 3), number - counter == 0 {
    True, True -> value
    True, False -> outer_loop(counter + 1, number, value + 2)
    False, _ -> outer_loop(counter, number, value + 2)
  }
}

fn is_prime(value: Int, divisor: Int) -> Bool {
  case value % divisor == 0, value / 2 >= divisor {
    False, True -> is_prime(value, divisor + 2)
    False, False -> True
    True, _ -> False
  }
}