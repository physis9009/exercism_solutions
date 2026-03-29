import gleam/list
import gleam/string
import gleam/int
import gleam/set.{type Set}

pub type Player {
  X
  O
}

type Position {
  Left
  Right
  Other
}

type Point {
  Point(row: Int, col: Int, stone: String, position: Position)
}

pub fn winner(board: String) -> Result(Player, Nil) {
  let rows = get_coordinate(board)
  let points = rows |> list.flatten
  let x_start = list.filter(points, fn(p) {p.position == Left && p.stone == "X"}) |> set.from_list
  let o_start = list.filter(points, fn(p) {p.row == 0 && p.stone == "O"}) |> set.from_list
  let x_connected = all_connected(points, x_start, x_start) |> set.to_list
  let o_connected = all_connected(points, o_start, o_start) |> set.to_list
  case x_wins(x_connected), o_wins(o_connected, list.length(rows) - 1) {
    True, False -> Ok(X)
    False, True -> Ok(O)
    _, _ -> case board {
      "X" -> Ok(X)
      "O" -> Ok(O)
      _ -> Error(Nil)
    }
  }
}

fn get_coordinate(board: String) -> List(List(Point)) {
  string.split(board, "\n")
  |> list.drop(1)
  |> list.map(string.to_graphemes)
  |> list.map(fn(l) {list.index_map(l, fn(char, i) {Point(0, i, char, Other)})})
  |> list.index_map(fn(l, i) {list.map(l, fn(p) {Point(i, p.col, p.stone, p.position)})})
  |> list.map(fn(l) {get_leftedge(l, []) |> get_rightedge})
}

fn get_leftedge(row: List(Point), first_half: List(Point)) -> List(Point) {
  case row {
    [first, ..rest] -> case first.stone == " " {
      True -> get_leftedge(rest, list.append(first_half, [first]))
      False -> list.append(first_half, [Point(first.row, first.col, first.stone, Left)]) |> list.append(rest)
    }
    _ -> panic as "invalid board"
  }
}

fn get_rightedge(row: List(Point)) -> List(Point) {
  let assert Ok(last) = list.last(row)
  list.take(row, list.length(row) - 1) |> list.append([Point(last.row, last.col, last.stone, Right)])
}

fn are_connected(point1: Point, point2: Point) -> Bool {
  case point1.stone == point2.stone {
    False -> False
    True -> case point1.row == point2.row && int.absolute_value(point1.col - point2.col) == 2 {
      True -> True
      False -> case int.absolute_value(point1.row - point2.row) == 1 && int.absolute_value(point1.col - point2.col) == 1 {
        True -> True
        False -> False
      }
    }
  }
}

fn all_connected(points: List(Point), start: Set(Point), acc: Set(Point)) -> Set(Point) {
  case set.is_empty(start) {
    True -> acc
    False -> {
      let found = list.filter(points, fn(p) {set.to_list(start) |> list.any(fn(a) {are_connected(a, p)})}) |> set.from_list
      all_connected(points, set.difference(found, start) |> set.difference(acc), set.union(found, acc))
    }
  }
}

fn x_wins(points: List(Point)) -> Bool {
  list.any(points, fn(p) {p.position == Left}) && list.any(points, fn(p) {p.position == Right})
}

fn o_wins(points: List(Point), last_row: Int) -> Bool {
  list.any(points, fn(p) {p.row == 0}) && list.any(points, fn(p) {p.row == last_row})
}