import gleam/int

pub type Classification {
  Perfect
  Abundant
  Deficient
}

pub type Error {
  NonPositiveInt
}

pub fn classify(number: Int) -> Result(Classification, Error) {
  case number > 0 {
    False -> Error(NonPositiveInt)
    True -> {
      let class = factors(number, 1, [])
      |> classification(number)
      Ok(class)
    }
  }
}

fn factors(number: Int, start: Int, acc: List(Int)) -> List(Int) {
  case start < number, number % start == 0 {
    False, _ -> acc
    True, True -> factors(number, start + 1, [start, ..acc])
    True, False -> factors(number, start + 1, acc)
  }
}

fn classification(factors: List(Int), number: Int) -> Classification {
  case int.sum(factors) - number {
    d if d == 0 -> Perfect
    d if d > 0 -> Abundant
    _ -> Deficient
  }
}