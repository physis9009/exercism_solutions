import gleam/list

pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep_loop(list, predicate, [])
}

fn keep_loop(list: List(t), predicate: fn(t) -> Bool, acc: List(t)) -> List(t) {
  case list {
    [] -> acc
    [first, ..rest] -> case predicate(first) {
      True -> keep_loop(rest, predicate, list.append(acc, [first]))
      False -> keep_loop(rest, predicate, acc)
    }
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  discard_loop(list, predicate, [])
}

fn discard_loop(list: List(t), predicate: fn(t) -> Bool, acc: List(t)) -> List(t) {
  case list {
    [] -> acc
    [first, ..rest] -> case predicate(first) {
      False -> discard_loop(rest, predicate, list.append(acc, [first]))
      True -> discard_loop(rest, predicate, acc)
    }
  }
}