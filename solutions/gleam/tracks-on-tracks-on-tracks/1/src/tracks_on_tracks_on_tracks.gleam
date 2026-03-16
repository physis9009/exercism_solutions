import gleam/list

pub fn new_list() -> List(String) {
  []
}

pub fn existing_list() -> List(String) {
  ["Gleam", "Go", "TypeScript"]
}

pub fn add_language(languages: List(String), language: String) -> List(String) {
  list.prepend(languages, language)
}

pub fn count_languages(languages: List(String)) -> Int {
  list.count(languages, fn(_a) {True})
}

pub fn reverse_list(languages: List(String)) -> List(String) {
  list.reverse(languages)
}

pub fn exciting_list(languages: List(String)) -> Bool {
  case languages {
    ["Gleam", .._] -> True
    [_, "Gleam"] -> True
    [_, "Gleam", _] -> True
    _ -> False
  }
}
