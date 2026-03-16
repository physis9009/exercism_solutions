import gleam/string
import gleam/list
import gleam/int

const digits = "0123456789X"
const coef = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

pub fn is_valid(isbn: String) -> Bool {
  let char_list = string.to_graphemes(isbn) |> list.filter(fn(char) {char != "-"})
  let digits_set = string.to_graphemes(digits)
  case list.length(char_list) == 10, x_check(char_list), list.all(char_list, fn(char) {list.contains(digits_set, char)}) {
    True, True, True -> list.map(char_list, fn(char) {
      case char {
        "X" -> "10"
        _ -> char
      }
    }) |> list.map(fn(char) {
      let assert Ok(num) = int.parse(char)
      num
    }) |> cal_check
    _, _, _ -> False
  }
}

fn x_check(char_list: List(String)) -> Bool {
  {list.count(char_list, fn(char) {char == "X"}) == 1 || list.count(char_list, fn(char) {char == "X"}) == 0} && !list.contains(list.take(char_list, 9), "X")
}

fn cal_check(nums: List(Int)) -> Bool {
  let cal = list.zip(nums, coef) |> list.fold(0, fn(acc, a) {acc + a.0 * a.1})
  cal % 11 == 0
}