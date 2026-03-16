import gleam/string

pub fn distance(strand1: String, strand2: String) -> Result(Int, Nil) {
  case string.length(strand1), string.length(strand2) {
    l1, l2 if l1 != l2 -> Error(Nil)
    _, _ -> Ok(count_difference(string.to_graphemes(strand1), string.to_graphemes(strand2), 0))
  }
}

fn count_difference(list1: List(String), list2: List(String), acc: Int) -> Int {
  case list1, list2 {
    [first1, ..rest1], [first2, ..rest2] if first1 != first2 -> count_difference(rest1, rest2, acc + 1)
    [first1, ..rest1], [first2, ..rest2] if first1 == first2 -> count_difference(rest1, rest2, acc)
    [], [] -> acc
    _, _ -> acc
  }
}