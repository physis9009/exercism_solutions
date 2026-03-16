import gleam/string
import gleam/list

pub fn reverse(value: String) -> String {
  string.split(value, "") |> list.reverse |> list.fold("", fn(acc, char) {acc <> char})
}
