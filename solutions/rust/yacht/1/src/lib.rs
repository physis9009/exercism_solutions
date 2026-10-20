#[derive(Debug)]
pub enum Category {
    Ones,
    Twos,
    Threes,
    Fours,
    Fives,
    Sixes,
    FullHouse,
    FourOfAKind,
    LittleStraight,
    BigStraight,
    Choice,
    Yacht,
}

type Dice = [u8; 5];

pub fn score(mut dice: Dice, category: Category) -> u8 {
    match category {
        Category::Ones => dice.iter().filter(|n| **n == 1).count() as u8,
        Category::Twos => (dice.iter().filter(|n| **n == 2).count() * 2) as u8,
        Category::Threes => (dice.iter().filter(|n| **n == 3).count() * 3) as u8,
        Category::Fours => (dice.iter().filter(|n| **n == 4).count() * 4) as u8,
        Category::Fives => (dice.iter().filter(|n| **n == 5).count() * 5) as u8,
        Category::Sixes => (dice.iter().filter(|n| **n == 6).count() * 6) as u8,
        Category::FullHouse => {
            let mut counts = [0_u8; 6];
            for d in dice {
                counts[d as usize - 1] += 1;
            }
            if counts.contains(&2) && counts.contains(&3) {
                dice.iter().sum()
            } else { 0 }
        }
        Category::FourOfAKind => {
            let mut counts = [0_u8; 6];
            for d in dice {
                counts[d as usize - 1] += 1;
            }
            if counts.contains(&4) || counts.contains(&5) {
                (counts.iter().position(|&c| c == 4 || c == 5).unwrap() + 1) as u8 * 4
            } else { 0 }
        }
        Category::LittleStraight => {
            dice.sort();
            if dice == [1, 2, 3, 4, 5] {
                30
            } else { 0 }
        }
        Category::BigStraight => {
            dice.sort();
            if dice == [2, 3, 4, 5, 6] {
                30
            } else { 0 }
        }
        Category::Choice => dice.iter().sum(),
        Category::Yacht => {
            let mut counts = [0_u8; 6];
            for d in dice {
                counts[d as usize - 1] += 1;
            }
            if counts.contains(&5) {
                50
            } else { 0 }
        }
    }
}
