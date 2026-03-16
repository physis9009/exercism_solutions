import gleam/int
import gleam/float

pub type Error {
  InvalidSquare
}

pub fn square(square: Int) -> Result(Int, Error) {
  case square {
    num if num < 65 && num > 0 -> {
      let assert Ok(general_term) = int.power(2, int.to_float(square - 1))
      Ok(float.truncate(general_term))
    }
    _ -> Error(InvalidSquare)
  }
}

pub fn total() -> Int {
  grains_list(1, []) |> int.sum
}

fn grains_list(squares: Int, acc: List(Int)) -> List(Int) {
  case squares {
    num if num > 64 -> acc
    _ -> {
      let assert Ok(grains) = square(squares)
      grains_list(squares + 1, [grains, ..acc])
    }
  }
}