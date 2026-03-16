import gleam/list

pub type Command {
  Wink
  DoubleBlink
  CloseYourEyes
  Jump
}

pub fn commands(encoded_message: Int) -> List(Command) {
  case <<encoded_message:5>> {
    <<first:1, a:1, b:1, c:1, d:1>> if first == 1 -> [#(a, Jump), #(b, CloseYourEyes), #(c, DoubleBlink), #(d, Wink)]
    <<first:1, a:1, b:1, c:1, d:1>> if first == 0 -> [#(d, Wink), #(c, DoubleBlink), #(b, CloseYourEyes), #(a, Jump)]
    _ -> []
  } |> list.filter_map(mapper)
}

fn mapper(item: #(Int, Command)) -> Result(Command, Nil) {
  case item.0 {
    1 -> Ok(item.1)
    0 | _ -> Error(Nil)
  }
}