import gleam/list
import gleam/int

pub type Item {
  Item(value: Int, weight: Int)
}

pub fn maximum_value(items: List(Item), maximum_weight: Int) -> Int {
  let sorted = list.sort(items, fn(a, b) {int.compare(a.weight, b.weight)})
  case max_count(sorted, maximum_weight, 0, 0), list.length(items) {
    0, _ -> 0
    mc, l if mc == l -> list.fold(items, 0, fn(acc, item) {acc + item.value})
    mc, _ -> comb_loop(items, mc, []) |> list.filter(fn(sub_list) {
      list.fold(sub_list, 0, fn(acc, item) {acc + item.weight}) <= maximum_weight
    }) |> list.map(fn(sub_list) {
      list.fold(sub_list, 0, fn(acc, item) {acc + item.value})
    }) |> list.fold(0, int.max)
  }
}

fn max_count(items: List(Item), maximum_weight: Int, w_acc: Int, c_acc: Int) -> Int {
  case items {
    [] -> c_acc
    [first, ..rest] -> {
      case w_acc + first.weight <= maximum_weight {
        True -> max_count(rest, maximum_weight, w_acc + first.weight, c_acc + 1)
        False -> c_acc
      }
    }
  }
}

fn comb_loop(items: List(Item), count: Int, acc: List(List(Item))) -> List(List(Item)) {
  case count {
    0 -> acc
    _ -> comb_loop(
      items,
      count - 1,
      list.append(acc, list.combinations(items, count))
    )
  }
}