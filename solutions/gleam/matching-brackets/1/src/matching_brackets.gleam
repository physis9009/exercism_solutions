import gleam/string
import gleam/list

pub fn is_paired(value: String) -> Bool {
  let brackets_list = string.to_graphemes(value)
  |> list.filter(fn(char) {char == "{" || char == "}" || char == "[" || char == "]" || char == "(" || char == ")"})

  check_brackets(brackets_list, [])
}

fn check_brackets(list: List(String), acc: List(String)) -> Bool {
  case list {
    [first, ..rest] if first == "[" || first == "{" || first == "(" -> check_brackets(rest, [first, ..acc])
    [first, ..rest] if first == "]" -> case acc {
      ["[", ..tail] -> check_brackets(rest, tail)
      _ -> False
    }
    [first, ..rest] if first == "}" -> case acc {
      ["{", ..tail] -> check_brackets(rest, tail)
      _ -> False
    }
    [first, ..rest] if first == ")" -> case acc {
      ["(", ..tail] -> check_brackets(rest, tail)
      _ -> False
    }
    [] -> list.is_empty(acc)
    _ -> False
  }
}