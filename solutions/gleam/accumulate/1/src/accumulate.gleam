import gleam/list

pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  acc_loop(list, fun, []) |> list.reverse
}

fn acc_loop(list: List(a), fun: fn(a) -> b, acc: List(b)) -> List(b) {
  case list {
    [] -> acc
    [first, ..rest] -> acc_loop(rest, fun, [fun(first), ..acc])
  }
}