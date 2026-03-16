// TODO: import the `gleam/int` module
// TODO: import the `gleam/float` module
// TODO: import the `gleam/string` module
import gleam/int
import gleam/float

pub fn pence_to_pounds(pence: Int) -> Float {
  let pence_f = int.to_float(pence)
  pence_f /. 100.0
}

pub fn pounds_to_string(pounds: Float) -> String {
  "£" <> float.to_string(pounds)
}
