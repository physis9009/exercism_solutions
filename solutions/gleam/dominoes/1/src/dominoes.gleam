import gleam/list
import gleam/dict

pub fn can_chain(chain: List(#(Int, Int))) -> Bool {
  case list.first(chain) {
    Error(_) -> True
    Ok(first) -> case pass_check(list.drop_while(chain, fn(t) {t == first}), first, []) || pass_check(list.drop_while(chain, fn(t) {t == first}) |> list.reverse, first, []) {
      False -> False
      True -> list.map(chain, fn(t) {[t.0, t.1]})
      |> list.flatten
      |> list.group(fn(n) {n})
      |> dict.values
      |> list.map(fn(l) {list.length(l)})
      |> list.all(fn(n) {n % 2 == 0})
    }
  }
}

fn pass_check(chain: List(#(Int, Int)), start: #(Int, Int), acc: List(#(Int, Int))) -> Bool {
  case chain {
    [first, ..rest] -> case first.0 == start.0 || first.1 == start.0 || first.0 == start.1 || first.1 == start.1 {
      True -> pass_check(list.append(rest, acc), first, [])
      False -> pass_check(rest, start, [first, ..acc])
    }
    [] -> case acc {
      [] -> True
      _ -> False
    }
  }
}