import gleam/dict.{type Dict}
import gleam/list
import gleam/string

const valid = "abcdefghijklmnopqrstuvwxyz0123456789"

pub fn count_words(input: String) -> Dict(String, Int) {
  let valid_list = string.to_graphemes(valid)
  let processed = string.lowercase(input)
  |> string.to_graphemes
  |> process(valid_list, "")
  |> string.split(" ")
  |> list.filter(fn(word) {word != ""})

  list.map(processed, fn(word) {#(word, list.count(processed, fn(w) {w == word}))})
  |> list.unique
  |> dict.from_list
}

fn process(check: List(String), target: List(String), acc: String) -> String {
  case check {
    [] -> acc
    [a, "'", b, ..tail] -> case list.contains(target, a) ,list.contains(target, b) {
      True, True -> process(tail, target, acc <> a <> "'" <> b)
      False, True -> process(tail, target, acc <> " " <> b)
      True, False -> process(tail, target, acc <> a <> " ")
      False, False -> process(tail, target, acc <> " ")
    }
    [first, ..rest] -> case list.contains(target, first) {
      True -> process(rest, target, acc <> first)
      False -> process(rest, target, acc <> " ")
    }
  }
}