import gleam/option.{type Option, Some, None}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    None -> "Mighty Magician"
    Some(n) -> n
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player.health, player.level {
    h, l if h <= 0 && l >=10 -> Some(Player(..player, health: 100, mana: Some(100)))
    h, l if h <= 0 && l < 10 -> Some(Player(..player, health: 100, mana: None))
    _, _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana, cost, player.health {
    None, c, h if c <= h -> #(Player(..player, health: h - c), 0)
    None, _, _ -> #(Player(..player, health: 0), 0)
    Some(m), c, _ if m >= c -> #(Player(..player, mana: Some(m - c)), 2 * c)
    Some(_), _, _ -> #(player, 0)
  }
}
