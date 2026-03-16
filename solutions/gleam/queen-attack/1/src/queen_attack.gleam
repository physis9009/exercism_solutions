import gleam/list

pub type Position {
  Position(row: Int, column: Int)
}

pub type Error {
  RowTooSmall
  RowTooLarge
  ColumnTooSmall
  ColumnTooLarge
}

pub fn create(queen: Position) -> Result(Nil, Error) {
  case queen.row, queen.column {
    x, _ if x < 0 -> Error(RowTooSmall)
    x, _ if x > 7 -> Error(RowTooLarge)
    _, y if y < 0 -> Error(ColumnTooSmall)
    _, y if y > 7 -> Error(ColumnTooLarge)
    _, _ -> Ok(Nil)
  }
}

pub fn can_attack(
  black_queen black_queen: Position,
  white_queen white_queen: Position,
) -> Bool {
  let diagonal_list = list.append(diagonal1(black_queen, []), diagonal2(black_queen, []))
  |> list.append(diagonal3(black_queen, [])) |> list.append(diagonal4(black_queen, []))
  list.contains(diagonal_list, white_queen) || black_queen.row == white_queen.row || black_queen.column == white_queen.column
}

fn diagonal1(queen: Position, acc: List(Position)) -> List(Position) {
  case create(queen) {
    Ok(_) -> diagonal1(Position(queen.row - 1, queen.column - 1), [queen, ..acc])
    Error(_) -> acc
  }
}

fn diagonal2(queen: Position, acc: List(Position)) -> List(Position) {
  case create(queen) {
    Ok(_) -> diagonal2(Position(queen.row + 1, queen.column - 1), [queen, ..acc])
    Error(_) -> acc
  }
}

fn diagonal3(queen: Position, acc: List(Position)) -> List(Position) {
  case create(queen) {
    Ok(_) -> diagonal3(Position(queen.row - 1, queen.column + 1), [queen, ..acc])
    Error(_) -> acc
  }
}

fn diagonal4(queen: Position, acc: List(Position)) -> List(Position) {
  case create(queen) {
    Ok(_) -> diagonal4(Position(queen.row + 1, queen.column + 1), [queen, ..acc])
    Error(_) -> acc
  }
}