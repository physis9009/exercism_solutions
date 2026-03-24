pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  stack(first, []) |> stack(second, _) |> reverse
}

fn stack(list: List(a), acc: List(a)) -> List(a) {
  case list {
    [] -> acc
    [first, ..rest] -> stack(rest, [first, ..acc])
  }
}

pub fn concat(lists: List(List(a))) -> List(a) {
  concat_loop(lists, []) |> reverse
}

fn concat_loop(lists: List(List(a)), acc: List(a)) -> List(a) {
  case lists {
    [] -> acc
    [first, ..rest] -> case first {
      [] -> concat_loop(rest, acc)
      [head, ..tail] -> stack(tail, [head, ..acc]) |> concat_loop(rest, _)
    }
  }
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  filter_loop(list, function, []) |> reverse
}

fn filter_loop(list: List(a), function: fn(a) -> Bool, acc: List(a)) -> List(a) {
  case list {
    [] -> acc
    [first, ..rest] -> case function(first) {
      True -> filter_loop(rest, function, [first, ..acc])
      False -> filter_loop(rest, function, acc)
    }
  }
}

pub fn length(list: List(a)) -> Int {
  count(list, 0)
}

fn count(list: List(a), acc: Int) -> Int {
  case list {
    [] -> acc
    [first, ..rest] -> count(rest, acc + 1)
  }
}

pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  map_loop(list, function, []) |> reverse
}

fn map_loop(list: List(a), function: fn(a) -> b, acc: List(b)) -> List(b) {
  case list {
    [] -> acc
    [first, ..rest] -> map_loop(rest, function, [function(first), ..acc])
  }
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [first, ..rest] -> foldl(rest, function(initial, first), function)
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  reverse(list) |> foldl(initial, function)
}

pub fn reverse(list: List(a)) -> List(a) {
  stack(list, [])
}