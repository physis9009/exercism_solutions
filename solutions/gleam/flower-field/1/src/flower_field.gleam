import gleam/string
import gleam/list
import gleam/int

type Coordinate(t) = #(#(Int, Int), t)

pub fn annotate(garden: String) -> String {
  let mapped = string.split(garden, "\n")
  |> list.map(string.to_graphemes)
  |> list.map(fn(l) {list.map(l, fn(a) {#(#(0, 0), a)})})
  |> give_coordinate
  let flattened = list.flatten(mapped)
  list.map(mapped, fn(sub_list) {list.map(sub_list, fn(a) {annotate_one(a, flattened)})})
  |> list.map(string.concat)
  |> string.join("\n")
}

fn give_coordinate(original: List(List(Coordinate(String)))) -> List(List(Coordinate(String))) {
  use sub_list, index <- list.index_map(original)
  use item, item_i <- list.index_map(sub_list)
  #(#(index, item_i), item.1)
}

fn annotate_one(square: Coordinate(String), board: List(Coordinate(String))) -> String {
  case square.1 {
    "*" -> "*"
    "_" -> case list.filter(board, fn(a) {
      int.absolute_value(a.0.0 - square.0.0) <= 1 && int.absolute_value(a.0.1 - square.0.1) <= 1
      }) |> list.count(fn(a) {a.1 == "*"}) {
      0 -> "_"
      c -> int.to_string(c)
    }
    _ -> panic
  }
}