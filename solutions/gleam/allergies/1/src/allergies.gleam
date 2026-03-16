import gleam/list

pub type Allergen {
  Eggs
  Peanuts
  Shellfish
  Strawberries
  Tomatoes
  Chocolate
  Pollen
  Cats
}

pub fn allergic_to(allergen: Allergen, score: Int) -> Bool {
  case <<score:size(8)>>, allergen {
    <<_:1, _:1, _:1, _:1, _:1, _:1, _:1, 1:1>>, Eggs -> True
    <<_:1, _:1, _:1, _:1, _:1, _:1, 1:1, _:1>>, Peanuts -> True
    <<_:1, _:1, _:1, _:1, _:1, 1:1, _:1, _:1>>, Shellfish -> True
    <<_:1, _:1, _:1, _:1, 1:1, _:1, _:1, _:1>>, Strawberries -> True
    <<_:1, _:1, _:1, 1:1, _:1, _:1, _:1, _:1>>, Tomatoes -> True
    <<_:1, _:1, 1:1, _:1, _:1, _:1, _:1, _:1>>, Chocolate -> True
    <<_:1, 1:1, _:1, _:1, _:1, _:1, _:1, _:1>>, Pollen -> True
    <<1:1, _:1, _:1, _:1, _:1, _:1, _:1, _:1>>, Cats -> True
    _, _ -> False
  }
}

pub fn list(score: Int) -> List(Allergen) {
  list.filter([Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats], fn(a) {allergic_to(a, score)})
}
