import gleam/list
import gleam/string

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction, position)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  string.to_graphemes(instructions) |> move_loop(create(direction, position))
}

fn turn(robot: Robot, instruction: String) -> Robot {
  case robot.direction, instruction {
    North, "R" -> Robot(..robot, direction: East)
    East, "R" -> Robot(..robot, direction: South)
    South, "R" -> Robot(..robot, direction: West)
    West, "R" -> Robot(..robot, direction: North)
    North, "L" -> Robot(..robot, direction: West)
    East, "L" -> Robot(..robot, direction: North)
    South, "L" -> Robot(..robot, direction: East)
    West, "L" -> Robot(..robot, direction: South)
    _, _ -> robot
  }
}

fn step(robot: Robot) -> Robot {
  case robot.direction, robot.position.x, robot.position.y {
    North, x, y -> Robot(..robot, position: Position(x, y + 1))
    East, x, y -> Robot(..robot, position: Position(x + 1, y))
    South, x, y -> Robot(..robot, position: Position(x, y - 1))
    West, x, y -> Robot(..robot, position: Position(x - 1, y))
  }
}

fn move_loop(instructions: List(String), robot: Robot) -> Robot {
  case instructions {
    ["A", ..rest] -> move_loop(rest, step(robot))
    [first, ..rest] -> move_loop(rest, turn(robot, first))
    [] -> robot
  }
}