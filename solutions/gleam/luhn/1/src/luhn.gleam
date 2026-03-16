import gleam/string
import gleam/list
import gleam/int
import gleam/result

const valid_chars = "0123456789"

pub fn valid(value: String) -> Bool {
  let graphemes = string.to_graphemes(value) |> list.filter(fn(a) {a != " "})
  case list.length(graphemes) > 1 && list.all(graphemes, fn(a) {string.contains(valid_chars, a)}) {
    False -> False
    True -> {
      let sum = list.map(graphemes, int.parse)
      |> result.values
      |> list.reverse
      |> double([])
      |> int.sum

      sum % 10 == 0
    }
  }
}

fn double(values: List(Int), acc: List(Int)) -> List(Int) {
  case values {
    [first, second, ..rest] -> case second * 2 {
      d if d > 9 -> double(rest, list.append(acc, [first, d - 9]))
      d -> double(rest, list.append(acc, [first, d]))
    }
    [last] -> list.append(acc, [last])
    [] -> acc
  }
}