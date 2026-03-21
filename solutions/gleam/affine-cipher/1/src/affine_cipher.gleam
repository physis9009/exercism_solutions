import gleam/string
import gleam/list
import gleam/dict.{type Dict}

pub type Error {
  KeyNotCoprime(Int, Int)
}

const letters = "abcdefghijklmnopqrstuvwxyz"
const nums = "0123456789"

pub fn encode(
  plaintext plaintext: String,
  a a: Int,
  b b: Int,
) -> Result(String, Error) {
  let indexed_letters = list.zip(list.range(0, 25), string.to_graphemes(letters)) |> dict.from_list
  let letters_with_indices = list.zip(string.to_graphemes(letters), list.range(0, 25)) |> dict.from_list
  case is_coprime(a, 2) {
    False -> Error(KeyNotCoprime(a, 26))
    True -> string.lowercase(plaintext)
    |> string.to_graphemes
    |> list.filter(fn(char) {string.contains(letters <> nums, char)})
    |> list.map(fn(char) {do_encode(char, letters_with_indices, indexed_letters, a, b)})
    |> list.sized_chunk(5)
    |> list.map(string.concat)
    |> string.join(" ")
    |> Ok
  }
}

fn is_coprime(a: Int, divisor: Int) -> Bool {
  case 26 % a == 0 {
    True -> False
    False -> case divisor <= a / 2 {
      False -> True
      True -> case a % divisor {
        0 -> case 26 % divisor {
          0 -> False
          _ -> is_coprime(a, divisor + 1)
        }
        _ -> is_coprime(a, divisor + 1)
      }
    }
  }
}

fn do_encode(char: String, l_w_i: Dict(String, Int), i_l: Dict(Int, String), a: Int, b: Int) -> String {
  case string.contains(letters, char) {
    False -> char
    True -> {
      let assert Ok(i) = dict.get(l_w_i, char)
      let assert Ok(output) = {a * i + b} % 26 |> dict.get(i_l, _)
      output
    }
  }
}

pub fn decode(
  ciphertext ciphertext: String,
  a a: Int,
  b b: Int,
) -> Result(String, Error) {
  let indexed_letters = list.zip(list.range(0, 25), string.to_graphemes(letters)) |> dict.from_list
  let letters_with_indices = list.zip(string.to_graphemes(letters), list.range(0, 25)) |> dict.from_list
  case is_coprime(a, 2) {
    False -> Error(KeyNotCoprime(a, 26))
    True -> string.to_graphemes(ciphertext)
    |> list.filter(fn(char) {string.contains(letters <> nums, char)})
    |> list.map(fn(char) {do_decode(char, letters_with_indices, indexed_letters, a, b)})
    |> string.concat
    |> Ok
  }
}

fn mmi_of(a: Int, x: Int) -> Int {
  case a * x % 26 == 1 {
    False -> mmi_of(a, x + 1)
    True -> x
  }
}

fn do_decode(char: String, l_w_i: Dict(String, Int), i_l: Dict(Int, String), a: Int, b: Int) -> String {
  case string.contains(letters, char) {
    False -> char
    True -> {
      let assert Ok(i) = dict.get(l_w_i, char)
      let assert Ok(output) = {mmi_of(a, 0) * {i - b} % 26 + 26} % 26 |> dict.get(i_l, _)
      output
    }
  }
}