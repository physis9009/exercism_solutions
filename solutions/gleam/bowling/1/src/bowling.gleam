import gleam/list
import gleam/int
import gleam/result

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

type State {
  Open
  Spare
  Strike
  Incomplete
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  case knocked_pins > 10 || knocked_pins < 0 {
    True -> Error(InvalidPinCount)
    False -> case is_complete(game) {
      True -> Error(GameComplete)
      False -> case game.frames {

        [] -> Game([Frame(rolls: [knocked_pins], bonus: [knocked_pins])]) |> Ok

        [first_frame] -> case state_of(first_frame.rolls) {
          Strike | Open | Spare -> {
            use frame <- result.map(update(first_frame, knocked_pins))
            [Frame([knocked_pins], [knocked_pins]), frame] |> Game
          }
          Incomplete -> {
            use frame <- result.map(update(first_frame, knocked_pins))
            [frame] |> Game
          }
        }

        [second_frame, first_frame] -> case state_of(second_frame.rolls) {
          Incomplete -> {
            use frame1 <- result.try(update(second_frame, knocked_pins))
            use frame2 <- result.map(update(first_frame, knocked_pins))
            [frame1, frame2] |> Game
          }
          _ -> {
            use frame1 <- result.try(update(second_frame, knocked_pins))
            use frame2 <- result.map(update(first_frame, knocked_pins))
            [Frame([knocked_pins], [knocked_pins]), frame1, frame2] |> Game
          }
        }

        [last_frame, second_last, third_last, ..rest] -> case state_of(last_frame.rolls), list.length(rest) {
          _, l if l == 7 -> {
            use l_frame <- result.try(update_10th(last_frame, knocked_pins))
            use frame2 <- result.try(update(second_last, knocked_pins))
            use frame3 <- result.map(update(third_last, knocked_pins))
            [l_frame, frame2, frame3, ..rest] |> Game
          }
          Incomplete, _ -> {
            use frame1 <- result.try(update(last_frame, knocked_pins))
            use frame2 <- result.try(update(second_last, knocked_pins))
            use frame3 <- result.map(update(third_last, knocked_pins))
            [frame1, frame2, frame3, ..rest] |> Game
          }
          _, _ -> {
            use frame1 <- result.try(update(last_frame, knocked_pins))
            use frame2 <- result.map(update(second_last, knocked_pins))
            [Frame([knocked_pins], [knocked_pins]), frame1, frame2, third_last, ..rest] |> Game
          }
        }

      }
    }
  }
}

fn is_complete(game: Game) -> Bool {
  case list.length(game.frames) == 10 {
    False -> False
    True -> {
      let assert Ok(last_frame) = list.first(game.frames)
      case last_frame.rolls {
        [_, _, _] -> True
        [_, 10] -> False
        [a, b] if a + b != 10 -> True
        _ -> False
      }
    }
  }
}

fn state_of(rolls: List(Int)) -> State {
  case rolls {
    [a, b] if a + b != 10 -> Open
    [10] -> Strike
    [a, b] if a + b == 10 -> Spare
    _ -> Incomplete
  }
}

fn update(frame: Frame, pins: Int) -> Result(Frame, Error) {
  case state_of(frame.rolls) {
    Open -> frame |> Ok
    Spare -> case list.length(frame.bonus) {
      3 -> frame |> Ok
      _ -> Frame(frame.rolls, [pins, ..frame.bonus]) |> Ok
    }
    Strike -> case list.length(frame.bonus) {
      3 -> frame |> Ok
      _ -> Frame(frame.rolls, [pins, ..frame.bonus]) |> Ok
    }
    Incomplete -> {
      let assert Ok(roll1) = list.first(frame.rolls)
      case roll1 + pins < 11 {
        True -> Frame([pins, ..frame.rolls], [pins, ..frame.bonus]) |> Ok
        False -> Error(InvalidPinCount)
      }
    }
  }
}

fn update_10th(frame: Frame, pins: Int) -> Result(Frame, Error) {
  case frame.rolls {
    [_, _, _] -> Error(GameComplete)
    [a, 10] if a + pins > 10 && a != 10 -> Error(InvalidPinCount)
    [a, b] if a + b != 10 && b != 10 -> Error(GameComplete)
    [a, b] if a + b == 10 -> Frame([pins, ..frame.rolls], [pins, ..frame.bonus]) |> Ok 
    _ -> Frame([pins, ..frame.rolls], [pins, ..frame.bonus]) |> Ok
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  case is_complete(game) {
    False -> Error(GameNotComplete)
    True -> list.map(game.frames, fn(f) {f.bonus})
    |> list.flatten
    |> int.sum
    |> Ok
  }
}
