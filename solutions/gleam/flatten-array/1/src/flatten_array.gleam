import gleam/list

pub type NestedList(a) {
  Null
  Value(a)
  List(List(NestedList(a)))
}

pub fn flatten(nested_list: NestedList(a)) -> List(a) {
  flatten_loop(nested_list, [])
}

fn flatten_loop(nested_list: NestedList(a), acc: List(a)) -> List(a) {
  case nested_list {
    Null -> acc
    Value(v) -> list.append(acc, [v])
    List([first, ..rest]) -> flatten_loop(List(rest), flatten_loop(first, acc))
    List([]) -> acc
  }
}