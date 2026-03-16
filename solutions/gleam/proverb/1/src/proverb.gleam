import gleam/list
import gleam/string

pub fn recite(inputs: List(String)) -> String {
  case inputs {
    [] -> ""
    [first, ..] -> list.window_by_2(inputs) |> filling_loop([]) |> list.append(["And all for the want of a " <> first <> "."]) |> string.join("\n")
  }
}

fn filling_loop(list: List(#(String, String)), acc: List(String)) -> List(String) {
  case list {
    [] -> acc
    [first, ..rest] -> {
      let line = "For want of a " <> first.0 <> " the " <> first.1 <> " was lost."
      filling_loop(rest, list.append(acc, [line]))
    }
  }
}