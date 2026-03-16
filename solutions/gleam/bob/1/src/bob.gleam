import gleam/string
import gleam/list

pub fn hey(remark: String) -> String {
  case is_empty(remark) {
    True -> "Fine. Be that way!"
    False -> case ends_with_qm(remark), contains_letters(remark), all_uppercase(remark) {
      True, True, True -> "Calm down, I know what I'm doing!"
      True, True, False -> "Sure."
      True, False, _ -> "Sure."
      False, True, True -> "Whoa, chill out!" 
      _, _, _ -> "Whatever."
    }
  }
}

fn ends_with_qm(remark: String) -> Bool {
  string.trim_end(remark) |> string.ends_with("?")
}

fn contains_letters(remark: String) -> Bool {
  let alphabet = "abcdefghijklmnopqrstuvwxyz" |> string.to_graphemes
  string.lowercase(remark) |> string.to_graphemes |> list.any(fn(item) {list.contains(alphabet, item)})
}

fn is_empty(remark: String) -> Bool {
  string.trim(remark) == ""
}

fn all_uppercase(remark: String) -> Bool {
  string.uppercase(remark) == remark
}