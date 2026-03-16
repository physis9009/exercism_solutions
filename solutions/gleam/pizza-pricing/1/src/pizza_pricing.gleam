import gleam/list

// TODO: please define the Pizza custom type
pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  case pizza {
    Margherita -> 7
    Caprese -> 9
    Formaggio -> 10
    ExtraSauce(kind) -> 1 + pizza_price(kind)
    ExtraToppings(kind) -> 2 + pizza_price(kind)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  let price_list = list.map(order, pizza_price)
  case list.count(order, fn(_item) {True}) {
    1 -> 3 + sum(price_list)
    2 -> 2 + sum(price_list)
    _ -> sum(price_list)
  }
}

fn sum(list: List(Int)) -> Int {
  case list.reduce(list, fn(acc, x) {acc + x}) {
    Ok(n) -> n
    Error(Nil) -> 0
  }
}