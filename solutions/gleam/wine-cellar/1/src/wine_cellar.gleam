import gleam/list

pub fn wines_of_color(wines: List(Wine), color: Color) -> List(Wine) {
  list.filter(wines, fn(wine) {
    case wine.color {
      c if c == color -> True
      _-> False
    }
  })
}

pub fn wines_from_country(wines: List(Wine), country: String) -> List(Wine) {
  list.filter(wines, fn(wine) {
    case wine.country {
      c if c == country -> True
      _ -> False
    }
  })
}

// Please define the required labelled arguments for this function
pub fn filter(wines: List(Wine), color color: Color, country country: String) -> List(Wine) {
  wines_of_color(wines, color) |> wines_from_country(country)
}

pub type Wine {
  Wine(name: String, year: Int, country: String, color: Color)
}

pub type Color {
  Red
  Rose
  White
}
