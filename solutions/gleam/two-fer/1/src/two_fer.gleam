import gleam/option.{type Option, Some, None}

pub fn two_fer(name: Option(String)) -> String {
  case name {
    Some(n) -> "One for " <> n <> ", one for me."
    None -> "One for you, one for me."
  }
}
