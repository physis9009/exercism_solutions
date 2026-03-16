import gleam/list
import gleam/int

const digits = [1, 2, 3, 4, 5, 6, 7, 8, 9]

pub fn combinations(
  size size: Int,
  sum sum: Int,
  exclude exclude: List(Int),
) -> List(List(Int)) {
  list.combinations(digits, size)
  |> list.filter(fn(sub_list) {
    list.fold(sub_list, 0, int.add) == sum
  })
  |> list.filter(fn(sub_list) {
    !list.any(sub_list, fn(num) {list.contains(exclude, num)})
  })
}
