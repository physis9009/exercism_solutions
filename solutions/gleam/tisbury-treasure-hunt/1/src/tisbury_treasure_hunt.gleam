import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  let #(s, i) = place_location
  #(i, s)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  case place_location_to_treasure_location(place_location) {
    location if location == treasure_location -> True
    _ -> False
  }
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  let #(_, place_location) = place
  let treasure_location_list = map_treasure_location_list(treasures)

  list.count(treasure_location_list, fn(treasure_location) {
    treasure_location_matches_place_location(place_location, treasure_location)
  })
}

fn map_treasure_location_list(treasures: List(#(String, #(Int, String)))) ->
  List(#(Int, String)) {
    list.map(treasures, fn(item) {item.1})
  }

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  let found_treasure_name = found_treasure.0
  let desired_treasure_name = desired_treasure.0
  let place_name = place.0

  case found_treasure_name, desired_treasure_name, place_name {
    "Brass Spyglass", _, "Abandoned Lighthouse" -> True
    "Amethyst Octopus", desired, "Stormy Breakwater" if desired == "Crystal Crab" || desired == "Glass Starfish" -> True
    "Vintage Pirate Hat", desired, "Harbor Managers Office" if desired == "Model Ship in Large Bottle" || desired == "Antique Glass Fishnet Float" -> True
    _, _, _ -> False
  }
}
