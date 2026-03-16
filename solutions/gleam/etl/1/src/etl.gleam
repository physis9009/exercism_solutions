import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  dict.to_list(legacy) |> list.map(fn(item) {rearrange_tuple(item, [])}) |> list.flatten |> dict.from_list
}

fn rearrange_tuple(tuple: #(Int, List(String)), acc: List(#(String, Int))) -> List(#(String, Int)) {
  case tuple {
    #(v, [first, ..rest]) -> rearrange_tuple(#(v, rest), [#(string.lowercase(first), v), ..acc])
    #(v, []) -> acc
  }
}