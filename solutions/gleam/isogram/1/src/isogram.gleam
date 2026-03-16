import gleam/list
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let graphemes = string.lowercase(phrase) |> string.to_graphemes |> list.filter(fn(item) {item != " " && item != "-"})
  list.unique(graphemes) == graphemes
}
