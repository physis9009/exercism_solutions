import gleam/set
import gleam/string

pub fn is_pangram(sentence: String) -> Bool {
  let alphabet = set.from_list(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"])
  string.lowercase(sentence) |> string.to_graphemes |> set.from_list |> set.intersection(alphabet) |> set.is_subset(alphabet, _)
}
