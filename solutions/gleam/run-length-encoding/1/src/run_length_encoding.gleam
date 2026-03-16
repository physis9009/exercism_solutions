import gleam/list
import gleam/string
import gleam/int

const num = "0123456789"

pub fn encode(plaintext: String) -> String {
  case plaintext {
    "" -> ""
    _ -> string.to_graphemes(plaintext)
    |> list.chunk(fn(a) {a})
    |> list.map(fn(l) {
      let assert Ok(f) = list.first(l)
      #(list.length(l), f)
    })
    |> list.map(fn(t) {
      case t.0 {
        1 -> t.1
        _ -> int.to_string(t.0) <> t.1
      }
    })
    |> string.concat
  }
}

pub fn decode(ciphertext: String) -> String {
  case ciphertext {
    "" -> ""
    _ -> string.to_graphemes(ciphertext)
    |> seperate("", [])
    |> list.map(prepare)
    |> list.map(fn(a) {list.repeat(a.1, a.0)})
    |> list.flatten
    |> string.concat
  }
}

fn seperate(ciphertext: List(String), segment: String, acc: List(String)) -> List(String) {
  case ciphertext {
    [first, second, ..rest] -> case string.contains(num, first), string.contains(num, second) {
      True, False -> seperate(rest, "", list.append(acc, [segment <> first <> second]))
      True, True -> seperate(list.prepend(rest, second), segment <> first, acc)
      False, _ -> seperate(list.prepend(rest, second), "", list.append(acc, ["1" <> first]))
    }
    [last] -> list.append(acc, ["1" <> last])
    [] -> acc
  }
}

fn prepare(segment: String) -> #(Int, String) {
  let assert Ok(n) = string.drop_end(segment, 1) |> int.parse
  let assert Ok(l) = string.last(segment)
  #(n, l)
}