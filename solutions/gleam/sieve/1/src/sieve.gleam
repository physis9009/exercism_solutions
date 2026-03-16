import gleam/list

pub fn primes_up_to(upper_bound: Int) -> List(Int) {
  case upper_bound >= 2 {
    True -> list.range(2, upper_bound) |> list.map(fn(num) {#(num, False)}) |> sieve_loop([], upper_bound) |> list.filter(fn(a) {!a.1}) |> list.map(fn(a) {a.0})  
    False -> []
  }
}

fn sieve_loop(check_list: List(#(Int, Bool)), acc: List(#(Int, Bool)), limit: Int) -> List(#(Int, Bool)) {
  case check_list {
    [first, ..rest] if first.1 == False -> mark_loop(rest, first.0, limit, []) |> sieve_loop(list.append(acc, [first]), limit)
    [first, ..rest] if first.1 == True -> sieve_loop(rest, acc, limit)
    _ -> acc
  }
}

fn mark_loop(check_list: List(#(Int, Bool)), multiplier: Int, limit: Int, acc: List(#(Int, Bool))) -> List(#(Int, Bool)) {
  let products = multiply_loop(multiplier, 2, limit, [])
  case check_list {
    [] -> acc
    [first, ..rest] -> case list.contains(products, first.0) {
      True -> mark_loop(rest, multiplier, limit, list.append(acc, [#(first.0, True)]))
      False -> mark_loop(rest, multiplier, limit, list.append(acc, [first]))
    }
  }
}

fn multiply_loop(multiplier: Int, coef: Int, limit: Int, acc: List(Int)) -> List(Int) {
  case multiplier * coef {
    p if p > limit -> acc
    p -> multiply_loop(multiplier, coef + 1, limit, [p, ..acc])
  }
}