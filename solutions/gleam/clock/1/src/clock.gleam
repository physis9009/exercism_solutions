import gleam/int
import gleam/string

pub type Clock {
  Clock(hour: Int, minute: Int)
}

pub fn create(hour hour: Int, minute minute: Int) -> Clock {
  let normalized_minutes = {hour * 60 + minute} % 1440
  let adjusted_minutes = case normalized_minutes {
    n if n < 0 -> n + 1440
    _ -> normalized_minutes
  }
  Clock(adjusted_minutes / 60, adjusted_minutes % 60)
}

pub fn add(clock: Clock, minutes minutes: Int) -> Clock {
  let normalized_minutes = {clock.hour * 60 + clock.minute + minutes} % 1440
  create(normalized_minutes / 60, normalized_minutes % 60)
}

pub fn subtract(clock: Clock, minutes minutes: Int) -> Clock {
  let normalized_minutes = {clock.hour * 60 + clock.minute - minutes} % 1440
  let adjusted_minutes = case normalized_minutes {
    n if n < 0 -> n + 1440
    _ -> normalized_minutes
  }
  create(adjusted_minutes / 60, adjusted_minutes % 60)
}

pub fn display(clock: Clock) -> String {
  {int.to_string(clock.hour) |> string.pad_start(2, "0")} <> ":" <> {int.to_string(clock.minute) |> string.pad_start(2, "0")}
}
