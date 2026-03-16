// TODO: please define the 'Coach' type
pub type Coach {
  Coach(
    name: String,
    former_player: Bool
  )
}
// TODO: please define the 'Stats' type
pub type Stats {
  Stats(
    wins: Int,
    losses: Int
  )
}
// TODO: please define the 'Team' type
pub type Team {
  Team(
    name: String,
    coach: Coach,
    stats: Stats
  )
}
pub fn create_coach(name: String, former_player: Bool) -> Coach {
  Coach(name, former_player)
}

pub fn create_stats(wins: Int, losses: Int) -> Stats {
  Stats(wins, losses)
}

pub fn create_team(name: String, coach: Coach, stats: Stats) -> Team {
  Team(name, coach, stats)
}

pub fn replace_coach(team: Team, coach: Coach) -> Team {
  Team(..team, coach: coach)
}

pub fn is_same_team(home_team: Team, away_team: Team) -> Bool {
  case home_team, away_team {
    h, a if h.name == a.name && h.coach == a.coach && h.stats == a.stats -> True
    _, _ -> False
  }
}

pub fn root_for_team(team: Team) -> Bool {
  case team {
    t if t.coach.name == "Gregg Popovich" || t.coach.former_player == True || t.name == "Chicago Bulls" || t.stats.wins >= 60 || t.stats.wins < t.stats.losses -> True
    _ -> False
  }
}
