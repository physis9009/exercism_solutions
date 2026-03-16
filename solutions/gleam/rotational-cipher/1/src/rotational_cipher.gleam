import gleam/list
import gleam/string
import gleam/dict.{type Dict}

const lowercases = "abcdefghijklmnopqrstuvwxyz"
const uppercases = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

pub fn rotate(shift_key: Int, text: String) -> String {
  let l_dict = string.to_graphemes(lowercases) |> zip(shift_key)
  let u_dict = string.to_graphemes(uppercases) |> zip(shift_key)
  string.to_graphemes(text) |> encrypt(l_dict, []) |> encrypt(u_dict, []) |> string.concat
}

fn transpose(chars: List(String), shift_key: Int) -> List(String) {
  list.drop(chars, shift_key) |> list.append(list.take(chars, shift_key))
}

fn zip(chars: List(String), shift_key: Int) -> Dict(String, String) {
  transpose(chars, shift_key) |> list.zip(chars, _) |> dict.from_list
}

fn encrypt(text: List(String), cipher: Dict(String, String), acc: List(String)) -> List(String) {
  case text {
    [] -> acc
    [first, ..rest] -> case dict.get(cipher, first) {
      Ok(c) -> encrypt(rest, cipher, list.append(acc, [c]))
      Error(_) -> encrypt(rest, cipher, list.append(acc, [first]))
    }
  }
}