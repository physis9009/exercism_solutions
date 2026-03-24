import gleam/list
import gleam/int
import gleam/option.{type Option, Some, None}
import gleam/dict.{type Dict}

pub type Error {
  ImpossibleTarget
}

pub fn find_fewest_coins(
  coins: List(Int),
  target: Int,
) -> Result(List(Int), Error) {
  case target {
    t if t < 0 -> Error(ImpossibleTarget)
    0 -> Ok([])
    _ -> min_track(coins, target, 1, dict.from_list([#(0, Some(#(0, 0)))]))
    |> output(target, [])
  }
}

fn min_track(coins: List(Int), target: Int, register: Int, acc: Dict(Int, Option(#(Int, Int)))) -> Dict(Int, Option(#(Int, Int))) {
  case register <= target {
    False -> acc
    True -> {
      let coin_list = list.filter(coins, fn(a) {a <= register})
      case register <= target {
        False -> acc
        True -> case coin_list {
          [] -> dict.insert(acc, register, None) |> min_track(coins, target, register + 1, _)
          _ -> list.map(coin_list, fn(a) {register - a}) 
          |> dict.take(acc, _) 
          |> record(register) 
          |> dict.insert(acc, register, _)
          |> min_track(coins, target, register + 1, _)
        }
      }
    }
  }
}

fn record(dict: Dict(Int, Option(#(Int, Int))), register: Int) -> Option(#(Int, Int)) {
  let available = dict.filter(dict, fn(_k, v) {v != None})
  case dict.is_empty(available) {
    True -> None
    False -> {
      let updater = dict.fold(available, #(-1, #(-1, -1)), fn(acc, k, v) {
        let assert Some(prop) = v
        case acc.0 < 0 || prop.0 < acc.1.0 {
          True -> #(k, prop)
          False -> acc
        }
      })
      Some(#(updater.1.0 + 1, register - updater.0))
    }
  }
}

fn output(track: Dict(Int, Option(#(Int, Int))), target: Int, acc: List(Int)) -> Result(List(Int), Error) {
  let assert Ok(node) = dict.get(track, target)
  case node {
    None -> Error(ImpossibleTarget)
    Some(prop) -> case target > 0 {
      True -> output(track, target - prop.1, [prop.1, ..acc])
      False -> Ok(acc)
    }
  }
}