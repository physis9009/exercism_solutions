import gleam/set
import gleam/string
import gleam/int
import gleam/list

pub fn largest_product(digits: String, span: Int) -> Result(Int, Nil) {
  let numbers = "0123456789"
  |> string.to_graphemes
  |> set.from_list
  
  case string.length(digits), span, string.to_graphemes(digits) |> set.from_list |> set.is_subset(numbers) {
    l, s, only_numbers if l < s || !only_numbers || s < 0 -> Error(Nil)
    _, s, _ if s == 0 -> Ok(1)
    _, _, _ -> string.to_graphemes(digits)
    |> list.map(str_to_num)
    |> product_loop(span, [])
    |> list.max(int.compare)
  }
}

fn str_to_num(str: String) -> Int {
  case str {
    "0" -> 0
    "1" -> 1
    "2" -> 2
    "3" -> 3
    "4" -> 4
    "5" -> 5
    "6" -> 6
    "7" -> 7
    "8" -> 8
    "9" -> 9
    _ -> panic as "must be a Int"
  }
}

fn product_loop(input: List(Int), span: Int, acc: List(Int)) -> List(Int) {
  case input, list.length(input), list.take(input, span) {
    [first, ..rest], l, new_list if l >= span -> product_loop(rest, span, [list.fold(new_list, 1, fn(a, i) {a * i}), ..acc])
    _, _, _ -> acc
  }
}