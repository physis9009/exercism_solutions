import gleam/list
import gleam/string

pub fn recite(
  start_bottles start_bottles: Int,
  take_down take_down: Int,
) -> String {
  fill_loop(start_bottles, take_down, []) |> string.join("\n") |> string.drop_end(1)
}

fn num_map(num: Int) -> String {
  case num {
    10 -> "Ten"
    9 -> "Nine"
    8 -> "Eight"
    7 -> "Seven"
    6 -> "Six"
    5 -> "Five"
    4 -> "Four"
    3 -> "Three"
    2 -> "Two"
    1 -> "One"
    0 -> "No"
    _ -> panic as "invalid number"
  }
}

fn fill_loop(start: Int, take_down: Int, lyrics: List(String)) -> List(String) {
  case take_down > 0 {
    False -> lyrics
    True -> case start {
      2 -> fill_loop(start - 1, take_down - 1, list.append(lyrics, [
        num_map(start) <> " green bottles hanging on the wall,\n" <> num_map(start) <> " green bottles hanging on the wall,\nAnd if one green bottle should accidentally fall,\nThere'll be " <> string.lowercase(num_map(start - 1)) <> " green bottle hanging on the wall.\n"
      ]))
      1 -> fill_loop(start - 1, take_down - 1, list.append(lyrics, [
        num_map(start) <> " green bottle hanging on the wall,\n" <> num_map(start) <> " green bottle hanging on the wall,\nAnd if one green bottle should accidentally fall,\nThere'll be " <> string.lowercase(num_map(start - 1)) <> " green bottles hanging on the wall.\n"
      ]))
      _ -> fill_loop(start - 1, take_down - 1, list.append(lyrics, [
        num_map(start) <> " green bottles hanging on the wall,\n" <> num_map(start) <> " green bottles hanging on the wall,\nAnd if one green bottle should accidentally fall,\nThere'll be " <> string.lowercase(num_map(start - 1)) <> " green bottles hanging on the wall.\n"
      ]))
    }
  }
}