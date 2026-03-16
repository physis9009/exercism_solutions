import gleam/list

pub fn square_of_sum(n: Int) -> Int {
  let sum = {n * n + n} / 2
  sum * sum
}

pub fn sum_of_squares(n: Int) -> Int {
  arithmetic_sequence(n, [1]) |> list.reverse |> list.map(fn(item) {item * item}) |> list.fold(0, fn(acc, item) {acc + item})
}

fn arithmetic_sequence(length: Int, acc: List(Int)) -> List(Int) {
  case list.length(acc) {
    l if l == length -> acc
    _ -> {
      let assert Ok(first) = list.first(acc)
      arithmetic_sequence(length, [first + 1, ..acc])
    }
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
