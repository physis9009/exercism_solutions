import gleam/string
import gleam/list
import gleam/int
import gleam/float
import gleam/result

const letters = "abcdefghijklmnopqrstuvwxyz0123456789"

pub fn ciphertext(plaintext: String) -> String {
  let normalized = string.lowercase(plaintext) |> string.to_graphemes |> list.filter(fn(char) {string.contains(letters, char)})
  let #(r, c) = normalized |> list.length |> cal_loop
  pad(normalized, r, c) |> list.sized_chunk(c) |> list.transpose |> list.map(string.concat) |> string.join(" ")
}

fn cal_loop(length: Int) -> #(Int, Int) {
  let guess = int.square_root(length) |> result.unwrap(0.0) |> float.truncate
  case guess * guess >= length {
    True -> #(guess, guess)
    False -> case {guess + 1} * guess >= length {
      True -> #(guess, guess + 1)
      False -> cal_loop(length + 1)
    }
  }
}

fn pad(normalized: List(String), row: Int, col: Int) -> List(String) {
  case row * col, list.length(normalized) {
    p, l if p == l -> normalized
    p, l -> list.repeat(" ", p - l) |> list.append(normalized, _)
  }
}