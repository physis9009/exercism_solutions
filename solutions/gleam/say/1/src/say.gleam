import gleam/list
import gleam/string

pub type Error {
  OutOfRange
}

pub fn say(number: Int) -> Result(String, Error) {
  case number >= 0 && number <= 999999999999 {
    False -> Error(OutOfRange)
    True -> case number {
      0 -> "zero" |> Ok
      _ -> break(number, 0, [])
      |> list.map(fn(a) {case a.0 {
        0 -> ""
        _ -> translate(a.0) <> " " <> convert(a.1)
      }})
      |> list.filter(fn(a) {a != ""})
      |> string.join(" ")
      |> string.trim
      |> Ok
    }
  }
}

fn base_case(num: Int) -> String {
  case num { 
    0 -> ""
    1 -> "one"
    2 -> "two"
    3 -> "three"
    4 -> "four"
    5 -> "five"
    6 -> "six"
    7 -> "seven"
    8 -> "eight"
    9 -> "nine"
    10 -> "ten"
    11 -> "eleven"
    12 -> "twelve"
    13 -> "thirteen"
    14 -> "fourteen"
    15 -> "fifteen"
    16 -> "sixteen"
    17 -> "seventeen"
    18 -> "eighteen"
    19 -> "nineteen"
    20 -> "twenty"
    30 -> "thirty"
    40 -> "forty"
    50 -> "fifty"
    60 -> "sixty"
    70 -> "seventy"
    80 -> "eighty"
    90 -> "ninety"
    n if n > 20 && n < 100 -> base_case(n / 10 * 10) <> "-" <> base_case(n % 10)
    _ -> panic
  }
}

fn break(num: Int, level: Int, acc: List(#(Int, Int))) -> List(#(Int, Int)) {
  let r = num % 1000
  let q = num / 1000
  case q < 1 {
    True -> list.prepend(acc, #(r, level))
    False -> break(q, level + 1, list.prepend(acc, #(r, level)))
  }
}

fn convert(level: Int) -> String {
  case level {
    1 -> "thousand"
    2 -> "million"
    3 -> "billion"
    0 -> ""
    _ -> panic
  }
}

fn translate(num: Int) -> String {
  case num / 100 {
    0 -> base_case(num)
    q -> base_case(q) <> " hundred " <> base_case(num % 100)
  }
}