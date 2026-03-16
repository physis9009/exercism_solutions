pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  case rule1(game), rule2(game), rule3(game), rule4(game) {
    Ok(_), new_game, Ok(_), Ok(_) -> {
      case game.player {
        Black -> Game(new_game.white_captured_stones, new_game.black_captured_stones, White, new_game.error)
        White -> Game(new_game.white_captured_stones, new_game.black_captured_stones, Black, new_game.error)
      }
    }
    Error(err), _, _, _ -> Game(game.white_captured_stones, game.black_captured_stones, game.player, err)
    _, _, Error(err), _ -> Game(game.white_captured_stones, game.black_captured_stones, game.player, err)
    _, _, _, Error(err) -> Game(game.white_captured_stones, game.black_captured_stones, game.player, err)
  }
}
