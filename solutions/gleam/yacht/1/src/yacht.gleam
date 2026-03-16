import gleam/list
import gleam/int
import gleam/set

pub type Category {
  Ones
  Twos
  Threes
  Fours
  Fives
  Sixes
  FullHouse
  FourOfAKind
  LittleStraight
  BigStraight
  Choice
  Yacht
}

pub fn score(category: Category, dice: List(Int)) -> Int {
  case category {
    Ones -> eval_ones(dice)
    Twos -> eval_twos(dice)
    Threes -> eval_threes(dice)
    Fours -> eval_fours(dice)
    Fives -> eval_fives(dice)
    Sixes -> eval_sixes(dice)
    FullHouse -> eval_fullhouse(dice)
    FourOfAKind -> eval_4onekind(dice)
    LittleStraight -> eval_littlestraight(dice)
    BigStraight -> eval_bigstraight(dice)
    Choice -> eval_choice(dice)
    Yacht -> eval_yacht(dice)
  }
}

fn eval_ones(dice: List(Int)) -> Int {
  list.count(dice, fn(num) {num == 1})
}

fn eval_twos(dice: List(Int)) -> Int {
  list.count(dice, fn(num) {num == 2}) * 2
}

fn eval_threes(dice: List(Int)) -> Int {
  list.count(dice, fn(num) {num == 3}) * 3
}

fn eval_fours(dice: List(Int)) -> Int {
  list.count(dice, fn(num) {num == 4}) * 4
}

fn eval_fives(dice: List(Int)) -> Int {
  list.count(dice, fn(num) {num == 5}) * 5
}

fn eval_sixes(dice: List(Int)) -> Int {
  list.count(dice, fn(num) {num == 6}) * 6
}

fn eval_fullhouse(dice: List(Int)) -> Int {
  let assert Ok(first) = list.first(dice)
  case list.length(list.unique(dice)) == 2, list.count(dice, fn(num) {num == first}) {
    True, l if l == 2 || l == 3 -> int.sum(dice)
    _, _ -> 0
  }
}

fn eval_4onekind(dice: List(Int)) -> Int {
  let assert Ok(first) = list.first(dice)
  case list.length(list.unique(dice)), list.count(dice, fn(num) {num == first}) {
    1, _ -> 4 * first
    2, l if l == 1 || l == 4 -> case dice {
      [a, b, _c, ..] if a == b -> 4 * a
      [a, _b, c, ..] if a == c -> 4 * a
      [_a, b, c, ..] if b == c -> 4 * b
      _ -> panic as "something goes wrong"
    }
    _, _ -> 0
  }
}

fn eval_littlestraight(dice: List(Int)) -> Int {
  case set.from_list(dice) == set.from_list([1, 2, 3, 4, 5]) {
    True -> 30
    False -> 0
  }
}

fn eval_bigstraight(dice: List(Int)) -> Int {
  case set.from_list(dice) == set.from_list([2, 3, 4, 5, 6]) {
    True -> 30
    False -> 0
  }
}

fn eval_choice(dice: List(Int)) -> Int {
  int.sum(dice)
}

fn eval_yacht(dice: List(Int)) -> Int {
  case list.length(list.unique(dice)) {
    1 -> 50
    _ -> 0
  }
}