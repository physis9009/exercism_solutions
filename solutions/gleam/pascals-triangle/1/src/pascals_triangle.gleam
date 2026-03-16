import gleam/list
import gleam/int

pub fn rows(n: Int) -> List(List(Int)) {
  pascal_loop([1], n, [])
}

fn pascal_loop(init: List(Int), n: Int, acc: List(List(Int))) -> List(List(Int)) {
  case n > 0 {
    False -> acc
    True -> pascal_loop(
      init |> list.append([0]) |> list.prepend(0) |> list.window(2) |> list.map(fn(l) {list.fold(l, 0, int.add)}),
      n - 1,
      list.append(acc, [init])
    )
  }
}