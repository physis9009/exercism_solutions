import gleam/list
import gleam/string
import gleam/result

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  string.to_graphemes(rna)
  |> list.sized_chunk(3)
  |> list.map(string.concat)
  |> trans_loop([])
  |> result.all
}

fn translate(rna: String) -> Result(String, Nil) {
  case rna {
    "AUG" -> Ok("Methionine")
    "UUU" | "UUC" -> Ok("Phenylalanine")
    "UUA" | "UUG" -> Ok("Leucine")
    "UCU" | "UCC" | "UCA" | "UCG" -> Ok("Serine")
    "UAU" | "UAC" -> Ok("Tyrosine")
    "UGU" | "UGC" -> Ok("Cysteine")
    "UGG" -> Ok("Tryptophan")
    "UAA" | "UAG" | "UGA" -> Ok("STOP")
    _ -> Error(Nil)
  }
}

fn trans_loop(rna: List(String), acc: List(Result(String, Nil))) -> List(Result(String, Nil)) {
  case rna {
    [first, ..rest] -> case translate(first) {
      Ok("STOP") -> acc
      Ok(_) -> trans_loop(rest, list.append(acc, [translate(first)]))
      _ -> [Error(Nil)]
    }
    [] -> acc
  }
}