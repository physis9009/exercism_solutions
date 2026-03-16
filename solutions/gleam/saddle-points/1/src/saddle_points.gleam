import gleam/list
import gleam/dict

pub type Position {
  Position(row: Int, column: Int)
}

pub fn saddle_points(matrix: List(List(Int))) -> List(Position) {
  let with_pos = list.map(matrix, fn(row) {list.map(row, fn(h) {#(h, Position(0, 0))})}) |> add_row(1, []) |> list.map(fn(row) {add_col(row, 1, [])})
  let high_in_row = with_pos |> list.map(fn(row) {list.filter(row, fn(the_tree) {list.all(row, fn(any_tree) {any_tree.0 <= the_tree.0})})}) |> list.flatten
  let low_in_col = with_pos |> list.flatten |> list.group(fn(tree) {tree.1.column}) |> dict.values |> list.map(fn(col) {list.filter(col, fn(the_tree) {list.all(col, fn(any_tree) {any_tree.0 >= the_tree.0})})}) |> list.flatten
  list.filter(high_in_row, fn(a) {list.contains(low_in_col, a)}) |> list.map(fn(tree) {tree.1})
}

fn add_row(matrix: List(List(#(Int, Position))), row: Int, acc: List(List(#(Int, Position)))) -> List(List(#(Int, Position))) {
  case matrix {
    [] -> acc
    [first, ..rest] -> add_row(rest, row + 1, list.append(acc, [list.map(first, fn(r) {#(r.0, Position(row, r.1.column))})]))
  }
}

fn add_col(row: List(#(Int, Position)),  col: Int, acc: List(#(Int, Position))) -> List(#(Int, Position)) {
  case row {
    [] -> acc
    [first, ..rest] -> add_col(rest, col + 1, list.append(acc, [#(first.0, Position(first.1.row, col))]))
  }
}