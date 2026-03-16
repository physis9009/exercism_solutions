import gleam/dict.{type Dict}
import gleam/list
import gleam/int
import gleam/string

pub type School {
  School(students: Dict(Int, List(String)))
}

pub fn create() -> School {
  School(dict.new())
}

pub fn roster(school: School) -> List(String) {
  dict.to_list(school.students) |> list.sort(fn(grade1, grade2) {int.compare(grade1.0, grade2.0)}) |> list.map(sort_students) |> list.map(tuple_to_list) |> list.flatten
}

fn sort_students(students: #(Int, List(String))) -> #(Int, List(String)) {
  #(students.0, list.sort(students.1, string.compare))
}

fn tuple_to_list(tuple: #(a, b)) -> b {
  tuple.1
}

pub fn add(
  to school: School,
  student student: String,
  grade grade: Int,
) -> Result(School, Nil) {
  case roster(school) |> list.contains(student) {
    True -> Error(Nil)
    False -> case dict.has_key(school.students, grade) {
      False -> Ok(School(dict.insert(school.students, grade, [student])))
      True -> {
        let inserted = dict.map_values(school.students, fn(g, l) {
          case g == grade {
            True -> [student, ..l]
            False -> l
          }
        })
        Ok(School(inserted))
      }
    }
  }
}

pub fn grade(school: School, desired_grade: Int) -> List(String) {
  dict.filter(school.students, fn(g, _l) {g == desired_grade}) |> dict.to_list |> list.map(sort_students) |> list.map(tuple_to_list) |> list.flatten
}
