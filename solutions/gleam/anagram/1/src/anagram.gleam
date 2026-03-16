import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  check_loop(candidates, word, []) |> list.reverse
}

fn is_anagram(word1: String, word2: String) -> Bool {
  case string.lowercase(word1), string.lowercase(word2) {
    w1, w2 if w1 == w2 -> False
    w1, w2 -> case string.length(w1) == string.length(w2) {
      False -> False
      True -> case list.sort(string.to_graphemes(w1), string.compare) == list.sort(string.to_graphemes(w2), string.compare) {
        False -> False
        True -> True
      }
    }
  }
}

fn check_loop(list: List(String), target: String, acc: List(String)) -> List(String) {
  case list {
    [] -> acc
    [first, ..rest] -> case is_anagram(first, target) {
      True -> check_loop(rest, target, [first, ..acc])
      False -> check_loop(rest, target, acc)
    }
  }
}