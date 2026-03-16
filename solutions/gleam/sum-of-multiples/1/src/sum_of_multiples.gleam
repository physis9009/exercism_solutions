import gleam/list
import gleam/set
import gleam/int

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  list.map(factors, fn(factor) {to_multiples(factor, limit, 1, [])})
  |> list.flatten
  |> set.from_list
  |> set.to_list
  |> int.sum
}

fn to_multiples(num: Int, limit: Int, multiplier: Int, acc: List(Int)) -> List(Int) {
  case num * multiplier {
    0 -> acc
    m if m >= limit -> acc
    m -> to_multiples(num, limit, multiplier + 1, [m, ..acc])
  }
}