import gleam/list
import gleam/string

type Coordinate {
  Coordinate(row: Int, col: Int, char: String)
}

type Rectangle {
  Rectangle(top: #(Coordinate, Coordinate), bottom: #(Coordinate, Coordinate))
}

pub fn rectangles(input: String) -> Int {
  let matrix = get_coordinate(input)
  let coors = list.flatten(matrix)
  list.map(matrix, fn(row) {list.filter(row, fn(coor) {coor.char == "+"})})
  |> list.map(list.combination_pairs)
  |> all_possible([])
  |> list.filter(fn(rect) {horizontal_valid(rect, coors) && vertical_valid(rect, coors)})
  |> list.length
}

fn get_coordinate(input: String) -> List(List(Coordinate)) {
  string.split(input, "\n")
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(fn(c) {list.index_map(c, fn(char, i) {Coordinate(i, 0, char)})})
  |> list.transpose
  |> list.map(fn(r) {list.index_map(r, fn(char, i) {Coordinate(char.row, i, char.char)})})
}

fn possible_rectangle(comb1: List(#(Coordinate, Coordinate)), comb2: List(#(Coordinate, Coordinate)), acc: List(Rectangle)) -> List(Rectangle) {
  case comb1 {
    [] -> acc
    [first, ..rest] -> case list.find(comb2, fn(a) {a.0.col == first.0.col && a.1.col == first.1.col}) {
      Error(_) -> possible_rectangle(rest, comb2, acc)
      Ok(edge) -> possible_rectangle(rest, comb2, [Rectangle(first, edge), ..acc])
    }
  }
}

fn all_possible(combs: List(List(#(Coordinate, Coordinate))), acc: List(Rectangle)) -> List(Rectangle) {
  case combs {
    [first, ..rest] -> case rest {
      [] -> all_possible(rest, acc)
      [_, ..] -> all_possible(rest, list.append(acc, list.fold(rest, [], fn(in, a) {
        list.append(in, possible_rectangle(first, a, []))
      })))
    }
    [] -> acc
  }
}

fn horizontal_valid(rect: Rectangle, coors: List(Coordinate)) -> Bool {
  let to_check = list.filter(coors, fn(coor) {{coor.row == rect.top.0.row || coor.row == rect.bottom.0.row} && coor.col > rect.top.0.col && coor.col < rect.top.1.col})
  case to_check {
    [] -> True
    _ -> list.all(to_check, fn(coor) {coor.char == "+" || coor.char == "-"})
  }
}

fn vertical_valid(rect: Rectangle, coors: List(Coordinate)) -> Bool {
  let to_check = list.filter(coors, fn(coor) {{coor.col == rect.top.0.col || coor.col == rect.top.1.col} && coor.row > rect.top.0.row && coor.row < rect.bottom.0.row})
  case to_check {
    [] -> True
    _ -> list.all(to_check, fn(coor) {coor.char == "+" || coor.char == "|"})
  }
}