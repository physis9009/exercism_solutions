import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import gleam/order.{Gt, Lt, Eq}
import gleam/result
import gleam/int

const num_pool = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

type Term {
  Term(letter: String, coef: Int)
}

pub fn solve(puzzle: String) -> Result(Dict(String, Int), Nil) {
  let equation = string.split(puzzle, " == ")
  let assert Ok(addends_str) = equation |> list.first
  let assert Ok(sum_str) = equation |> list.last

  let addends = addends_str
    |> string.split(" + ")
    |> list.map(string.to_graphemes)

  let sum = string.to_graphemes(sum_str)

  let addend_terms = addends
    |> list.map(fn(word) {
      word
      |> list.reverse
      |> get_coef(0, [])
    })
    |> list.flatten

  let sum_terms = sum
    |> list.reverse
    |> get_coef(0, [])
    |> list.map(fn(t) { Term(t.letter, -1 * t.coef) })

  let polynomial = list.append(addend_terms, sum_terms)
    |> list.group(fn(t) { t.letter })
    |> dict.values
    |> list.map(fn(group) {
      list.fold(group, Term("", 0), fn(acc, t) {
        Term(t.letter, acc.coef + t.coef)
      })
    })
    |> list.filter(fn(t) { t.coef != 0 })
    |> list.sort(fn(t1, t2) {
      case int.compare(int.absolute_value(t1.coef), int.absolute_value(t2.coef)) {
        Gt -> Lt
        Lt -> Gt
        Eq -> Eq
      }
    })

  let inits = {
    let all_words = list.append(addends, [sum])
    all_words
    |> list.map(fn(word) { list.first(word) |> result.unwrap("") })
    |> list.filter(fn(c) { c != "" })
    |> list.unique
  }

  let vars = list.map(polynomial, fn(t) { t.letter })

  case search(polynomial, num_pool, inits, 0) {
    Ok(assignment) -> {
      dict.from_list(list.zip(vars, assignment))
      |> Ok
    }
    Error(Nil) -> Error(Nil)
  }
}

fn get_coef(word_rev: List(String), power: Int, acc: List(Term)) -> List(Term) {
  case word_rev {
    [] -> acc
    [first, ..rest] -> {
      let value = list.fold(list.range(0, power), 1, fn(prod, _) { prod * 10 })
      get_coef(rest, power + 1, [Term(first, value), ..acc])
    }
  }
}

fn max_possible(
  poly: List(Term),
  remaining_digits: List(Int),
  inits: List(String),
  current_sum: Int,
) -> Int {
  let sorted_digits = list.sort(remaining_digits, int.compare)
  let desc_digits = list.reverse(sorted_digits)

  let #(sum, _) = list.fold(poly, #(current_sum, #(sorted_digits, desc_digits)), fn(acc, term) {
    let #(total, #(asc_digits, desc_digits)) = acc
    case term.coef > 0 {
      True -> {
        case desc_digits {
          [largest, ..rest_desc] -> #(total + term.coef * largest, #(asc_digits, rest_desc))
          [] -> #(total, #(asc_digits, desc_digits))
        }
      }
      False -> {
        let candidate = case list.contains(inits, term.letter) {
          True -> list.find(asc_digits, fn(d) { d != 0 }) |> result.unwrap(0)
          False -> case asc_digits {
            [smallest, ..rest_asc] -> smallest
            [] -> 0
          }
        }
        case candidate {
          0 -> #(total, #(asc_digits, desc_digits))
          d -> {
            let new_asc = list.filter(asc_digits, fn(x) { x != d })
            let new_desc = list.filter(desc_digits, fn(x) { x != d })
            #(total + term.coef * d, #(new_asc, new_desc))
          }
        }
      }
    }
  })
  sum
}

fn min_possible(
  poly: List(Term),
  remaining_digits: List(Int),
  inits: List(String),
  current_sum: Int,
) -> Int {
  let sorted_digits = list.sort(remaining_digits, int.compare)
  let desc_digits = list.reverse(sorted_digits)

  let #(sum, _) = list.fold(poly, #(current_sum, #(sorted_digits, desc_digits)), fn(acc, term) {
    let #(total, #(asc_digits, desc_digits)) = acc
    case term.coef < 0 {
      True -> {
        case desc_digits {
          [largest, ..rest_desc] -> #(total + term.coef * largest, #(asc_digits, rest_desc))
          [] -> #(total, #(asc_digits, desc_digits))
        }
      }
      False -> {
        let candidate = case list.contains(inits, term.letter) {
          True -> list.find(asc_digits, fn(d) { d != 0 }) |> result.unwrap(0)
          False -> case asc_digits {
            [smallest, ..rest_asc] -> smallest
            [] -> 0
          }
        }
        case candidate {
          0 -> #(total, #(asc_digits, desc_digits))
          d -> {
            let new_asc = list.filter(asc_digits, fn(x) { x != d })
            let new_desc = list.filter(desc_digits, fn(x) { x != d })
            #(total + term.coef * d, #(new_asc, new_desc))
          }
        }
      }
    }
  })
  sum
}

fn check_modulo_constraint(
  poly: List(Term),
  assigned: List(#(String, Int)),
) -> Bool {
  let unit_terms = list.filter(poly, fn(t) { t.coef % 10 != 0 })
  let sum = list.fold(unit_terms, 0, fn(acc, t) {
    case list.key_find(assigned, t.letter) {
      Ok(value) -> acc + t.coef * value
      Error(Nil) -> acc
    }
  })
  sum % 10 == 0
}

fn try_digits(
  digits: List(Int),
  term: Term,
  rest_poly: List(Term),
  remaining: List(Int),
  inits: List(String),
  current_sum: Int,
) -> Result(List(Int), Nil) {
  case digits {
    [] -> Error(Nil)
    [digit, ..rest_digits] -> {
      case list.contains(inits, term.letter) && digit == 0 {
        True -> try_digits(rest_digits, term, rest_poly, remaining, inits, current_sum)
        False -> {
          let new_sum = current_sum + term.coef * digit
          let new_remaining = list.filter(remaining, fn(d) { d != digit })

          let max_poss = max_possible(rest_poly, new_remaining, inits, new_sum)
          let min_poss = min_possible(rest_poly, new_remaining, inits, new_sum)

          case max_poss < 0 || min_poss > 0 {
            True -> try_digits(rest_digits, term, rest_poly, remaining, inits, current_sum)
            False -> {
              case search(rest_poly, new_remaining, inits, new_sum) {
                Ok(tail) -> {
                  
                  let current_assigned = list.append([#(term.letter, digit)], list.zip(list.map(rest_poly, fn(t) { t.letter }), tail))
                  case check_modulo_constraint(list.prepend(rest_poly, term), current_assigned) {
                    True -> Ok([digit, ..tail])
                    False -> try_digits(rest_digits, term, rest_poly, remaining, inits, current_sum)
                  }
                }
                Error(Nil) -> try_digits(rest_digits, term, rest_poly, remaining, inits, current_sum)
              }
            }
          }
        }
      }
    }
  }
}

fn search(
  poly: List(Term),
  remaining: List(Int),
  inits: List(String),
  current_sum: Int,
) -> Result(List(Int), Nil) {
  case poly {
    [] -> case current_sum == 0 {
      True -> Ok([])
      False -> Error(Nil)
    }

    [term, ..rest_poly] -> {
      try_digits(remaining, term, rest_poly, remaining, inits, current_sum)
    }
  }
}