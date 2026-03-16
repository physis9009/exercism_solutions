import gleam/string
import gleam/list

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  case string.to_graphemes(input) |> list.length, size {
    0, _ -> Error(EmptySeries)
    _, 0 -> Error(SliceLengthZero)
    _, s if s < 0 -> Error(SliceLengthNegative)
    l, s if l < s -> Error(SliceLengthTooLarge)
    _, _ -> Ok(list.reverse(slice_loop(string.to_graphemes(input), size, [])))
  }
}

pub type Error {
  SliceLengthTooLarge
  SliceLengthZero
  SliceLengthNegative
  EmptySeries
}

fn slice_loop(input: List(String), num: Int, acc: List(String)) -> List(String) {
  case input, list.length(input), num {
    [first, ..rest], l, n if l >= n -> slice_loop(rest, num, [string.concat(list.take(input, num)), ..acc])
    _, _, _ -> acc
  }
}