import gleam/int
import gleam/list
import gleam/string
import gleam/result

pub type Resistance {
  Resistance(unit: String, value: Int)
}

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  use l <- result.try(bands_to_list(colors))
  list_to_value(l)
}

fn color_to_num(color: String) -> Result(String, Nil) {
  case color {
    "black" -> Ok("0")
    "brown" -> Ok("1")
    "red" -> Ok("2") 
    "orange" -> Ok("3")    
    "yellow" -> Ok("4")    
    "green" -> Ok("5")    
    "blue" -> Ok("6")    
    "violet" -> Ok("7")    
    "grey" -> Ok("8")    
    "white" -> Ok("9")
    _ -> Error(Nil)
  }
}

fn bands_to_list(color: List(String)) -> Result(List(String), Nil) {
  case color {
    [a, b, c, ..] -> case color_to_num(a), color_to_num(b), color_to_num(c) {
      Ok(n1), Ok(n2), Ok(n3) -> {
        let assert Ok(zero_digits) = int.parse(n3)
        let l = [n1, n2] |> list.append(list.repeat("0", zero_digits))
        Ok(l)
      }
      _, _, _ -> Error(Nil)
    }
    _ -> Error(Nil)
  }
}

fn list_to_value(l: List(String)) -> Result(Resistance, Nil) {
  case list.length(l), list.reverse(l) |> count_zeros(0) {
    len, n if len == n -> Ok(Resistance("ohms", 0))
    _, n if n < 3 -> {
      let assert Ok(value) = int.parse(string.concat(l))
      Ok(Resistance("ohms", value))
    }
    _, n if n >= 3 && n < 6 -> {
      let assert Ok(value) = list.reverse(l) |> list.drop(3) |> list.reverse |> string.concat |> int.parse
      Ok(Resistance("kiloohms", value))
    }
    _, n if n >= 6 && n < 9 -> {
      let assert Ok(value) = list.reverse(l) |> list.drop(6) |> list.reverse |> string.concat |> int.parse
      Ok(Resistance("megaohms", value))
    }
    _, n if n >= 9 -> {
      let assert Ok(value) = list.reverse(l) |> list.drop(9) |> list.reverse |> string.concat |> int.parse
      Ok(Resistance("gigaohms", value))
    }
    _, _ -> Error(Nil)
  }
}

fn count_zeros(l: List(String), acc: Int) -> Int {
  case l {
    [first, ..rest] if first == "0" -> count_zeros(rest, acc + 1)
    [first, ..] if first != "0" -> acc
    [] | _ -> acc
  }
}