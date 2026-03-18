import gleam/list

pub type Comparison {
  Equal
  Unequal
  Sublist
  Superlist
}

pub fn sublist(compare list_a: List(a), to list_b: List(a)) -> Comparison {
  let length_a = list.length(list_a)
  let length_b = list.length(list_b)
  case list_a == list_b {
    True -> Equal
    False -> case length_a > length_b, length_a < length_b {
      True, False -> case list.window(list_a, length_b) |> list.contains(list_b) || length_b == 0 {
        True -> Superlist
        False -> Unequal
      }
      False, True -> case list.window(list_b, length_a) |> list.contains(list_a) || length_a == 0 {
        True -> Sublist
        False -> Unequal
      }
      _, _ -> Unequal
    }
  }
}
