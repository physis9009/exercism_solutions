// The code below is a stub. Just enough to satisfy the compiler.
// In order to pass the tests you can add-to or change any of this code.

#[derive(PartialEq, Eq, Debug)]
pub enum Direction {
    North,
    East,
    South,
    West,
}

pub struct Robot {
    x: i32,
    y: i32,
    d: Direction,
}

impl Robot {
    pub fn new(x: i32, y: i32, d: Direction) -> Self {
        Robot {x, y, d}
    }

    #[must_use]
    pub fn turn_right(self) -> Self {
        match self.d {
            Direction::North => Robot {x: self.x, y: self.y, d: Direction::East},
            Direction::East => Robot {x: self.x, y: self.y, d: Direction::South},
            Direction::South => Robot {x: self.x, y: self.y, d: Direction::West},
            Direction::West => Robot {x: self.x, y: self.y, d: Direction::North},
        }
    }

    #[must_use]
    pub fn turn_left(self) -> Self {
        match self.d {
            Direction::North => Robot {x: self.x, y: self.y, d: Direction::West},
            Direction::East => Robot {x: self.x, y: self.y, d: Direction::North},
            Direction::South => Robot {x: self.x, y: self.y, d: Direction::East},
            Direction::West => Robot {x: self.x, y: self.y, d: Direction::South},
        }
    }

    #[must_use]
    pub fn advance(self) -> Self {
        match self.d {
            Direction::North => Robot {x: self.x, y: self.y + 1, d: self.d},
            Direction::East => Robot {x: self.x + 1, y: self.y, d: self.d},
            Direction::South => Robot {x: self.x, y: self.y - 1, d: self.d},
            Direction::West => Robot {x: self.x - 1, y: self.y, d: self.d},
        }
    }

    #[must_use]
    pub fn instructions(self, instructions: &str) -> Self {
        let mut robot = self;
        for inst in instructions.chars() {
            match inst {
                'R' => robot = robot.turn_right(),
                'L' => robot = robot.turn_left(),
                _ => robot = robot.advance(),
            }
        }
        robot
    }

    pub fn position(&self) -> (i32, i32) {
        (self.x, self.y)
    }

    pub fn direction(&self) -> &Direction {
        &self.d
    }
}
