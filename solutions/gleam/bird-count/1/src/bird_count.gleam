import gleam/list

pub fn today(days: List(Int)) -> Int {
  let today_result = list.first(days)
  case today_result {
    Ok(n) -> n
    Error(Nil) -> 0
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [today, ..rest] -> [today + 1, ..rest]
    [] -> [1]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case list.find(days, fn(item) {item == 0}) {
    Ok(_) -> True
    Error(Nil) -> False
  }
}

pub fn total(days: List(Int)) -> Int {
  let sum_result = list.reduce(days, fn(acc, x) {acc + x})
  case sum_result {
    Ok(sum) -> sum
    Error(Nil) -> 0
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  list.count(days, fn(item) {item >= 5})
}
