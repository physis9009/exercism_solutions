import gleam/string
import gleam/list
import gleam/int

pub fn row(index: Int, string: String) -> Result(List(Int), Nil) {
  let matrix = string_to_matrix(string)
  case list.length(matrix) {
    l if l < index -> Error(Nil)
    _ -> Ok(index_list(matrix, index, 1))
  }
}

pub fn column(index: Int, string: String) -> Result(List(Int), Nil) {
  let matrix = string_to_matrix(string)
  case list.length(index_list(matrix, 1, 1)) {
    l if l < index -> Error(Nil)
    _ -> {
      let col = extract_loop(matrix, index, []) |> list.reverse
      Ok(col)
    }
  }
}

fn string_to_matrix(str: String) -> List(List(Int)) {
  string.split(str, "\n")
  |> list.map(fn(row) {string.split(row, " ")})
  |> list.map(fn(row) {
    list.map(row, fn(item) {
      let assert Ok(num) = int.parse(item)
      num
    }) 
  })
}

fn index_list(list: List(a), index: Int, acc: Int) -> a {
  case list, index - acc {
    [_, ..rest], d if d > 0 -> index_list(rest, index, acc + 1)
    [first, ..], d if d == 0 -> first
    _, _ -> panic
  }
}

fn extract_loop(rows: List(List(Int)), index: Int, acc: List(Int)) -> List(Int) {
  case rows {
    [] -> acc
    [first, ..rest] -> extract_loop(rest, index, [index_list(first, index, 1), ..acc])
  }
}