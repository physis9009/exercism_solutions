import gleam/string
import gleam/list
import gleam/dict
import gleam/order.{type Order, Lt, Gt}
import gleam/int

type Entry {
  Entry(team: String, mp: Int, w: Int, d: Int, l: Int, p: Int)
}

type Result {
  Result(h: String, a: String, r: String)
}

pub fn tally(input: String) -> String {
  case input {
    "" -> "Team                           | MP |  W |  D |  L |  P"
    _ -> string.split(input, "\n") |> list.map(fn(s) {string.split(s, ";")}) |> list.map(transform) |> add_loop([]) |> list.group(fn(a) {a.team}) |> dict.values |> list.map(fn(a) {combine(a, Entry("", 0, 0, 0, 0, 0))}) |> list.sort(compare) |> list.map(to_row) |> list.prepend("Team                           | MP |  W |  D |  L |  P") |> string.join("\n")
  }
}

fn transform(input: List(String)) -> Result {
  case input {
    [a, b, c, ..] -> Result(a, b, c)
    _ -> panic as "invalid result 1"
  }
}

fn add_loop(input: List(Result), acc: List(Entry)) -> List(Entry) {
  case input {
    [] -> acc
    [first, ..rest] -> add_loop(rest, add(acc, first))
  }
}

fn add(entries: List(Entry), one: Result) -> List(Entry) {
  case one.r {
    "win" -> list.append(entries, [Entry(one.h, 1, 1, 0, 0, 3), Entry(one.a, 1, 0, 0, 1, 0)])
    "loss" -> list.append(entries, [Entry(one.h, 1, 0, 0, 1, 0), Entry(one.a, 1, 1, 0, 0, 3)])
    "draw" -> list.append(entries, [Entry(one.h, 1, 0, 1, 0, 1), Entry(one.a, 1, 0, 1, 0, 1)])
    _ -> panic as "invalid result 2"
  }
} 

fn combine(entries: List(Entry), acc: Entry) -> Entry {
  case entries {
    [] -> acc
    [first, ..rest] -> combine(rest, Entry(first.team, first.mp + acc.mp, first.w + acc.w, first.d + acc.d, first.l + acc.l, first.p + acc.p))
  }
}

fn compare(a: Entry, b: Entry) -> Order {
  case a.p == b.p {
    True -> string.compare(a.team, b.team)
    False -> case a.p > b.p {
      True -> Lt
      False -> Gt
    }
  }
}

fn to_row(entry: Entry) -> String {
  let length = string.length(entry.team)
  let first_half = entry.team <> string.drop_start("Team                           ", length) <> "|  " <> int.to_string(entry.mp) <> " |  " <> int.to_string(entry.w) <> " |  " <> int.to_string(entry.d) <> " |  " <> int.to_string(entry.l)
  case entry.p > 9 {
    False -> first_half <> " |  " <> int.to_string(entry.p)
    True -> first_half <> " | " <> int.to_string(entry.p)
  }
} 