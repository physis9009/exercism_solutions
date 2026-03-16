import gleam/string
import gleam/list

pub fn first_letter(name: String) {
  case string.trim(name) |> string.first {
    Ok(first_letter) -> first_letter
    Error(Nil) -> "invalid name"
  }
}

pub fn initial(name: String) {
  string.uppercase(first_letter(name)) <> "."
 }

pub fn initials(full_name: String) {
  case string.split(full_name, " ") {
    [..name_list] -> list.map(name_list, fn(item) {initial(item)}) |> string.join(" ") 
    [] -> ""
  }
}

pub fn pair(full_name1: String, full_name2: String) {
  let pattern = "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     X. X.  +  X. X.     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
  string.replace(pattern, "X. X.  +", initials(full_name1) <> "  +") 
  |> string.replace("+  X. X.", "+  " <> initials(full_name2))
}
