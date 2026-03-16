import gleam/int
import gleam/list

pub type Character {
  Character(
    charisma: Int,
    constitution: Int,
    dexterity: Int,
    hitpoints: Int,
    intelligence: Int,
    strength: Int,
    wisdom: Int,
  )
}

const dice = [1, 2, 3, 4, 5, 6]

pub fn generate_character() -> Character {
  let character = Character(ability(), ability(), ability(), ability(), ability(), ability(), ability())
  Character(..character, hitpoints: modifier(character.constitution) + 10)
}

pub fn modifier(score: Int) -> Int {
  let assert Ok(q) = int.floor_divide(score - 10, 2)
  q
}

pub fn ability() -> Int {
  sample_loop(dice, 4, []) |> list.sort(int.compare) |> list.drop(1) |> list.fold(0, int.add)
}

fn sample_loop(dice: List(Int), num: Int, acc: List(Int)) -> List(Int) {
  case list.sample(dice, 1), num > 0 {
    [item, ..], True -> sample_loop(dice, num - 1, [item, ..acc])
    _, _ -> acc
  }
}