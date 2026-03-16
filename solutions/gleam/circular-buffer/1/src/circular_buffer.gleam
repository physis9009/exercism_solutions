import gleam/list

type Buffer(t) {
  Buffer(read: List(t), write: List(t), max_length: Int)
}

pub opaque type CircularBuffer(t) {
  CircularBuffer(Buffer(t))
}

pub fn new(capacity: Int) -> CircularBuffer(t) {
  CircularBuffer(Buffer([], [], capacity))
}

pub fn read(buffer: CircularBuffer(t)) -> Result(#(t, CircularBuffer(t)), Nil) {
  let CircularBuffer(Buffer(r, w, ml)) = buffer
  case r {
    [] -> Error(Nil)
    [first, ..rest] -> #(
      first,
      Buffer(rest, list.reverse(rest), ml) |> CircularBuffer
    ) |> Ok
  }
}

pub fn write(
  buffer: CircularBuffer(t),
  item: t,
) -> Result(CircularBuffer(t), Nil) {
  let CircularBuffer(Buffer(r, w, ml)) = buffer
  case list.length(w) < ml {
    True -> {
      let updated = [item, ..w]
      Buffer(list.reverse(updated), updated, ml) |> CircularBuffer |> Ok
    }
    False -> Error(Nil)
  }
}

pub fn overwrite(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  let CircularBuffer(Buffer(r, w, ml)) = buffer
  case list.length(w) < ml {
    True -> {
      let assert Ok(updated) = write(buffer, item)
      updated    
    }
    False -> {
      let updated = r |> list.drop(1) |> list.append([item])
      Buffer(updated, list.reverse(updated), ml) |> CircularBuffer
    }
  }
}

pub fn clear(buffer: CircularBuffer(t)) -> CircularBuffer(t) {
  let CircularBuffer(Buffer(_, _, ml)) = buffer
  new(ml)
}