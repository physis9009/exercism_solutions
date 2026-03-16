import gleam/string
import gleam/list

pub fn to_rna(dna: String) -> Result(String, Nil) {
  let rna_list = string.split(dna, "") |> list.map(fn(nuc) {
    case nuc {
      "G" -> "C"
      "C" -> "G"
      "T" -> "A"
      "A" -> "U"
      _ -> "None"
    }
  })
  case list.any(rna_list, fn(char) {char == "None"}) {
    True -> Error(Nil)
    False -> Ok(string.concat(rna_list))
  }
}
