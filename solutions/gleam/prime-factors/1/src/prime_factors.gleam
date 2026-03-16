import gleam/list

pub fn factors(value: Int) -> List(Int) {
  factor_loop(value, 2, []) 
}

fn is_prime(num: Int, div: Int) -> Bool {
  case num {
    1 -> False
    2 -> True
    _ -> case num % 2 == 0 {
      True -> False
      False -> case div > {num / 2} {
        True -> True
        False -> case num % div == 0 {
          True -> False
          False -> is_prime(num, div + 2)
        }
      }
    }
  }
}

fn factor_loop(value: Int, acc: Int, factors: List(Int)) -> List(Int) {
  case value {
    1 -> factors
    _ -> case acc > {value / 2} {
      True -> list.append(factors, [value])
      False -> case value % acc == 0 {
        False -> factor_loop(value, acc + 1, factors)
        True -> case is_prime(acc, 3) {
          True -> factor_loop(value / acc, acc, list.append(factors, [acc]))
          False -> factor_loop(value, acc + 1, factors)
        }
      }
    }
  }
}