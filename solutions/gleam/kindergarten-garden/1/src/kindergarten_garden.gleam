import gleam/string
import gleam/list

pub type Student {
  Alice
  Bob
  Charlie
  David
  Eve
  Fred
  Ginny
  Harriet
  Ileana
  Joseph
  Kincaid
  Larry
}

pub type Plant {
  Radishes
  Clover
  Violets
  Grass
}

pub fn plants(diagram: String, student: Student) -> List(Plant) {
  string.split(diagram, "\n")
  |> list.map(fn(row) {string.slice(row, student_to_index(student), 2)})
  |> list.map(string.to_graphemes)
  |> list.flatten
  |> list.map(abbr_to_plant)
}

fn student_to_index(name: Student) -> Int {
  case name {
    Alice -> 0
    Bob -> 2
    Charlie -> 4
    David -> 6
    Eve -> 8
    Fred -> 10
    Ginny -> 12
    Harriet -> 14
    Ileana -> 16
    Joseph -> 18
    Kincaid -> 20
    Larry -> 22
  }
}

fn abbr_to_plant(abbr: String) -> Plant {
  case abbr {
    "R" -> Radishes
    "C" -> Clover
    "V" -> Violets
    "G" | _ -> Grass
  }
}