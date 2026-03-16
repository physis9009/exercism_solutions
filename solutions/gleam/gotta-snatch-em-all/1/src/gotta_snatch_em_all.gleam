import gleam/set.{type Set}
import gleam/list
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.new() |> set.insert(card)
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  let possible = set.contains(collection, my_card) && !set.contains(collection, their_card)
  
  #(possible, set.insert(collection, their_card) |> set.delete(my_card))
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
    let first_collection = case list.first(collections) {
      Ok(c) -> c
      Error(Nil) -> set.from_list([])
    }
    common_cards(collections, first_collection) |> set.to_list
}

fn common_cards(collections: List(Set(String)), acc: Set(String)) -> Set(String) {
  case collections {
    [] -> acc
    [first, ..rest] -> common_cards(rest, set.intersection(first, acc))
  }
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  union_cards(collections, set.from_list([])) |> set.to_list |> list.count(fn(_a) {True})
}

fn union_cards(collections: List(Set(String)), acc: Set(String)) -> Set(String) {
  case collections {
    [] -> acc
    [first, ..rest] -> union_cards(rest, set.union(first, acc))
  }
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.to_list(collection) |> list.filter(fn(card) {string.contains(card, "Shiny ")}) |> set.from_list
}
