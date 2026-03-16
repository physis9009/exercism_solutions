import gleam/list
import gleam/string

pub type Output {
  Unknown
  Digit(Int)
  List(List(Output))
}

pub type Error {
  InvalidLineNumber
  InvalidRowNumber
}

pub fn convert(input: String) -> Result(Output, Error) {
  let sym_list = string.split(input, "\n") |> list.drop(1)
  case list.length(sym_list) % 4 == 0, list.all(sym_list, fn(row) {string.length(row) % 3 == 0}) {
    _, False -> Error(InvalidRowNumber)
    False, _ -> Error(InvalidLineNumber)
    _, _ -> case list.length(sym_list) == 4 && list.all(sym_list, fn(row) {string.length(row) == 3}) {
      True -> Ok(num_convert(sym_list))
      False -> {
        let wanted = sym_list |> list.sized_chunk(4) |> list.map(fn(a) {reorganize(a, [])})
        case wanted {
          [a] -> Ok(a)
          _ -> Ok(List(wanted))
        }
      }
    }
  }
}


fn num_convert(sym_list: List(String)) -> Output {
  case sym_list {
    [" _ ", "| |", "|_|", "   "] -> Digit(0)
    ["   ", "  |", "  |", "   "] -> Digit(1)
    [" _ ", " _|", "|_ ", "   "] -> Digit(2)
    [" _ ", " _|", " _|", "   "] -> Digit(3)
    ["   ", "|_|", "  |", "   "] -> Digit(4)
    [" _ ", "|_ ", " _|", "   "] -> Digit(5)
    [" _ ", "|_ ", "|_|", "   "] -> Digit(6)
    [" _ ", "  |", "  |", "   "] -> Digit(7)
    [" _ ", "|_|", "|_|", "   "] -> Digit(8)
    [" _ ", "|_|", " _|", "   "] -> Digit(9)
    _ -> Unknown
  }
}

fn reorganize(sym_list: List(String), acc: List(List(String))) -> Output {
  let first3 = list.map(sym_list, fn(a) {string.slice(a, 0, 3)})
  case first3 {
    ["", "", "", ""] -> List(acc |> list.map(num_convert))
    _ -> reorganize(list.map(sym_list, fn(a) {string.drop_start(a, 3)}), list.append(acc, [first3]))
  }
}