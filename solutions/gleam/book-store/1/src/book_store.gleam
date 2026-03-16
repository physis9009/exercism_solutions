import gleam/list
import gleam/int
import gleam/dict

pub fn lowest_price(books: List(Int)) -> Float {
  let result = list.group(books, fn(id) {id}) |> dict.values |> list.map(fn(a) {list.length(a)}) |> search_loop
  -1 * result |> int.to_float
}

fn eval(group_num: Int) -> Int {
  case group_num {
    1 -> -800
    2 -> -1520
    3 -> -2160
    4 -> -2560
    5 -> -3000
    _ -> panic as "something goes wrong"
  }
}

fn search_loop(state: List(Int)) -> Int {
  let normalized = list.filter(state, fn(a) {a != 0}) |> list.sort(int.compare) |> list.reverse
  case list.max(combine_loop(normalized, list.length(normalized), []), int.compare) {
    Ok(result) -> result
    Error(Nil) -> 0
  }
}

fn combine_loop(state: List(Int), n: Int, acc: List(Int)) -> List(Int) {
  case n > 0 {
    False -> acc
    True -> {
      let updated = list.take(state, n) |> list.map(fn(a) {a - 1}) |> list.append(list.drop(state, n))
      combine_loop(
        state,
        n - 1,
        [eval(n) + search_loop(updated), ..acc]
      )
    }
  }
}