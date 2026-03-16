import gleam/dict.{type Dict}
import gleam/string
import gleam/list

pub fn nucleotide_count(dna: String) -> Result(Dict(String, Int), Nil) {
  let nuc_list = string.to_graphemes(dna)
  case nuc_list |> list.any(fn(char) {char != "A" && char != "C" && char != "G" && char != "T"}) {
    True -> Error(Nil)
    False -> {
      let nuc_dict = dict.from_list([#("A", 0), #("C", 0), #("G", 0), #("T", 0)])
      |> dict.map_values(fn(nuc, _) {
        case nuc {
          "A" -> list.count(nuc_list, fn(n) {n == "A"})
          "C" -> list.count(nuc_list, fn(n) {n == "C"})
          "G" -> list.count(nuc_list, fn(n) {n == "G"})
          "T" -> list.count(nuc_list, fn(n) {n == "T"})
          _ -> panic
        }
      })
      Ok(nuc_dict)
    }
  }
}
