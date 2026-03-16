import gleam/list
import gleam/string
import gleam/dict

const letters = "abcdefghijklmnopqrstuvwxyz"
const revs = "zyxwvutsrqponmlkjihgfedcba"
const nums = "0123456789"

pub fn encode(phrase: String) -> String {
  string.lowercase(phrase)|> string.to_graphemes |> list.filter(is_valid) |> list.map(trans) |> list.sized_chunk(5) |> list.map(string.concat) |> string.join(" ")
}

pub fn decode(phrase: String) -> String {
  string.to_graphemes(phrase) |> list.filter(is_valid) |> list.map(trans) |> string.concat
}

fn is_valid(char: String) -> Bool {
  string.to_graphemes(letters <> nums) |> list.contains(char)
}

fn trans(char: String) -> String {
  let trans_dict = string.to_graphemes(letters) |> list.zip(string.to_graphemes(revs)) |> dict.from_list 
  case dict.get(trans_dict, char) {
    Ok(v) -> v
    Error(_) -> char
  }
}