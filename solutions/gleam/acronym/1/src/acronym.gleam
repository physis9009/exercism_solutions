import gleam/string
import gleam/list

const valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZ- "

pub fn abbreviate(phrase phrase: String) -> String {
  string.uppercase(phrase) |> string.to_graphemes |> list.filter(fn(char) {list.contains(string.to_graphemes(valid), char)}) |> string.concat |> string.replace("-", " ") |> string.split(" ") |> to_acronym("")
}

fn to_acronym(phrase: List(String), acc: String) -> String {
  case phrase {
    [first, ..rest] -> case string.trim(first) |> string.first {
      Ok(letter) -> to_acronym(rest, acc <> letter)
      Error(_) -> to_acronym(rest, acc)
    }
    [] -> acc
  }
}