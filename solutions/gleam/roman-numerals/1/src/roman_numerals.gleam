import gleam/list
import gleam/string
import gleam/int

pub fn convert(number: Int) -> String {
  int.to_string(number) |> string.to_graphemes |> list.map(roman_map) |> trans_loop([]) |> list.map(digit_map) |> string.concat
}

fn trans_loop(digits: List(String), acc: List(#(String, Int))) -> List(#(String, Int)) {
  case digits {
    [first, ..rest] -> trans_loop(rest, list.append(acc, [#(first, list.length(digits))]))
    [] -> acc
  }
}

fn roman_map(number: String) -> String {
  case number {
    "0" -> ""
    "1" -> "I"
    "2" -> "II"
    "3" -> "III"
    "4" -> "IV"
    "5" -> "V"
    "6" -> "VI"
    "7" -> "VII"
    "8" -> "VIII"
    "9" -> "IX"
    _ -> panic
  }
}

fn digit_map(digit: #(String, Int)) -> String {
  case digit.1 {
    1 -> digit.0
    2 -> digit.0 |> string.replace("I", "x") |> string.replace("V", "L") |> string.replace("X", "C") |> string.replace("x", "X")
    3 -> digit.0 |> string.replace("I", "C") |> string.replace("V", "D") |> string.replace("X", "M")
    _ -> digit.0 |> string.replace("I", "M")
  }
}