import gleam/string
import gleam/list

pub fn translate(phrase: String) -> String {
  string.split(phrase, " ") |> list.map(translate_one) |> string.join(" ")
}

fn translate_one(word: String) -> String {
  case word, string.to_graphemes(word) {
    str, lst -> case starts_with_vowel(lst) {
      True -> str <> "ay"
      False -> case starts_with_xryt(str) {
        True -> str <> "ay"
        False -> case starts_with_qu(str) {
          True -> switch_qu(str) <> "ay"
          False -> case start_has_qu(lst) {
            True -> do_switch_qu(lst) <> "ay"
            False -> case str {
              "y" <> rest -> rest <> "y" <> "ay"
              _ -> switch_consonants(lst, [])
              |> string.concat <> "ay"
            }

          }
        }
      }
    }
  }
}

fn is_vowel(letter: String) -> Bool {
  case letter {
    "a" | "e" | "i" | "o" | "u" -> True
    _ -> False
  }
}

fn starts_with_vowel(list: List(String)) -> Bool {
  case list {
    [first, ..] -> is_vowel(first)
    _ -> is_vowel("")
  }
}

fn starts_with_xryt(word: String) -> Bool {
  case word {
    "xr" <> _ -> True
    "yt" <> _ -> True
    _ -> False
  }
}

fn starts_with_qu(word: String) -> Bool {
  case word {
    "qu" <> _ -> True
    _ -> False
  }
}

fn start_has_qu(list: List(String)) -> Bool {
  case list {
    [first, ..rest] -> case is_vowel(first), string.concat(rest) |> starts_with_qu {
      False, True -> True
      _, _ -> False
    }
    [] -> False
  }
}

fn switch_qu(word: String) -> String {
  case word {
    "qu" <> rest -> rest <> "qu"
    _ -> word
  }
}

fn do_switch_qu(lst: List(String)) -> String {
  case lst {
    [first, ..rest] -> list.append(rest, [first]) |> string.concat |> switch_qu
    [] -> ""
  }
}

fn switch_consonants(lst: List(String), acc: List(String)) -> List(String) {
  case lst, starts_with_vowel(lst) {
    [first, ..rest], False if first != "y" -> switch_consonants(rest, list.append(acc, [first]))
    _, True -> list.append(lst, acc)
    _, _ -> list.append(lst, acc)
  }
}