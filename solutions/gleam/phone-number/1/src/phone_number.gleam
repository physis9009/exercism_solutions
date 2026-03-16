import gleam/string
import gleam/list
import gleam/result

const letters = "abcdefghijklmnopqrstuvwxyz"
const valid_puncs = "()+-. "
const zero_nine = "0123456789"

pub fn clean(input: String) -> Result(String, String) {
  use char_list <- result.try(no_letters(input))
  use char_list <- result.try(no_puncs(char_list))
  use num_list <- result.try(correct_digits(char_list))
  final_check(num_list)
}

fn no_letters(input: String) -> Result(List(String), String) {
  let l_list = string.to_graphemes(letters)
  let i_list = string.to_graphemes(input)
  case list.any(i_list, fn(a) {list.contains(l_list, a)}) {
    True -> Error("letters not permitted")
    False -> Ok(i_list)
  }
}

fn no_puncs(input: List(String)) -> Result(List(String), String) {
  let vp_list = string.to_graphemes(valid_puncs)
  let zn_list = string.to_graphemes(zero_nine)
  case list.filter(input, fn(a) {!list.contains(list.append(vp_list, zn_list), a)}) {
    [] -> Ok(input)
    _ -> Error("punctuations not permitted")
  }
}

fn correct_digits(input: List(String)) -> Result(List(String), String) {
  let zn_list = string.to_graphemes(zero_nine)
  let num_list = list.filter(input, fn(a) {list.contains(zn_list, a)})
  case list.length(num_list) {
    l if l < 10 -> Error("must not be fewer than 10 digits")
    l if l > 11 -> Error("must not be greater than 11 digits")
    _ -> Ok(num_list)
  }
}

fn final_check(input: List(String)) -> Result(String, String) {  
  case list.length(input) {
    10 -> case input {
      ["0", ..] -> Error("area code cannot start with zero")
      ["1", ..] -> Error("area code cannot start with one")
      [_, _, _, "0", ..] -> Error("exchange code cannot start with zero")
      [_, _, _, "1", ..] -> Error("exchange code cannot start with one")
      _ -> string.concat(input) |> Ok
    }
    11 -> case input {
      [first, ..] if first != "1" -> Error("11 digits must start with 1")
      _ -> final_check(list.drop(input, 1))
    }
    _ -> panic as "something goes wrong"
  }
}