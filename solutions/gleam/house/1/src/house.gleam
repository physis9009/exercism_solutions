import gleam/string
import gleam/list

const verses = [
  "This is the malt that lay in",
  "This is the rat that ate",
  "This is the cat that killed",
  "This is the dog that worried",
  "This is the cow with the crumpled horn that tossed",
  "This is the maiden all forlorn that milked",
  "This is the man all tattered and torn that kissed",
  "This is the priest all shaven and shorn that married",
  "This is the rooster that crowed in the morn that woke",
  "This is the farmer sowing his corn that kept",
  "This is the horse and the hound and the horn that belonged to"
]

pub fn recite(start_verse start_verse: Int, end_verse end_verse: Int) -> String {
  form_rhyme(start_verse, end_verse, []) |> list.reverse |> string.join("\n")
}

fn form_one_verse(verses_list: List(String), acc: String) -> String {
  case verses_list {
    [] -> acc
    [first, ..rest] -> form_one_verse(rest, string.replace(acc, "This is", first))
  }
}

fn form_any_verse(num: Int) -> String {
  list.take(verses, num - 1) |> form_one_verse("This is the house that Jack built.")
}

fn form_rhyme(start_verse: Int, end_verse: Int, acc: List(String)) -> List(String) {
  case end_verse < start_verse {
    True -> acc
    False -> form_rhyme(start_verse + 1, end_verse, [form_any_verse(start_verse), ..acc])
  }
}