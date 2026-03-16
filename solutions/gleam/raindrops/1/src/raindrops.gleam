import gleam/int
import gleam/string

pub fn convert(number: Int) -> String {
  let result = convert_loop(number, [#(7, "Plong"), #(5, "Plang"), #(3, "Pling")], [])
  case result {
    [] -> int.to_string(number)
    _ -> string.join(result, "")
  }
}

fn convert_loop(number: Int, divisors: List(#(Int, String)), acc: List(String)) -> List(String) {
  case divisors {
    [first, ..rest] if number % first.0 == 0 -> convert_loop(number, rest, [first.1, ..acc])
    [first, ..rest] if number % first.0 != 0 -> convert_loop(number, rest, acc)
    [] | [_, ..] -> acc
  }
}