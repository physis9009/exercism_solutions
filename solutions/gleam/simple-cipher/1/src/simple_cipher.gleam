import gleam/string
import gleam/list

pub fn encode(plaintext plaintext: String, key key: String) -> String {
  let to_pad = string.length(plaintext) - string.length(key)
  case to_pad > 0 {
    True -> encode(plaintext, key <> string.slice(key, 0, to_pad))
    False -> do_encode(plaintext, key)
  }
}

fn to_shift(key: String) -> List(Int) {
  string.to_utf_codepoints(key) |> list.map(fn(a) {string.utf_codepoint_to_int(a) - 97})
}

fn combine(key: List(Int), plaintext: String) -> List(#(String, Int)) {
  string.to_graphemes(plaintext) |> list.zip(key)
}

fn do_encode(plaintext: String, key: String) -> String {
  to_shift(key)
  |> combine(plaintext)
  |> list.map(fn(a) {
    let assert [cp, ..] = string.to_utf_codepoints(a.0)
    let assert Ok(letter) = {string.utf_codepoint_to_int(cp) - 97 + a.1} % 26 + 97 |> string.utf_codepoint
    letter
  })
  |> string.from_utf_codepoints
}

pub fn decode(ciphertext ciphertext: String, key key: String) -> String {
  let to_pad = string.length(ciphertext) - string.length(key)
  case to_pad > 0 {
    True -> decode(ciphertext, key <> string.slice(key, 0, to_pad))
    False -> do_decode(ciphertext, key)
  }
}

fn do_decode(plaintext: String, key: String) -> String {
  to_shift(key)
  |> combine(plaintext)
  |> list.map(fn(a) {
    let assert [cp, ..] = string.to_utf_codepoints(a.0)
    let assert Ok(letter) = {string.utf_codepoint_to_int(cp) - a.1 - 71} % 26 + 97 |> string.utf_codepoint
    letter
  })
  |> string.from_utf_codepoints
}

pub fn generate_key() -> String {
  let letters = "abcdefghijklmnopqrstuvwxyz" |> string.to_graphemes
  list.repeat(letters, 4) |> list.flatten |> list.shuffle |> list.take(100)  |> string.concat
}
