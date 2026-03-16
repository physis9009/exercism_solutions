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
        Black -> Game(..new_game, player: White)
        White -> Game(..new_game, player: Black)
      }
    }
    Error(err), _, _, _ -> Game(..game, error: err)
    _, _, Error(err), _ -> Game(..game, error: err)
    _, _, _, Error(err) -> Game(..game, error: err)
  }
}
