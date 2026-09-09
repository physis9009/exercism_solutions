use std::collections::HashMap;

pub struct Allergies {
    score: u32,
    score_map: HashMap<u32, Allergen>,
}

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
pub enum Allergen {
    Eggs,
    Peanuts,
    Shellfish,
    Strawberries,
    Tomatoes,
    Chocolate,
    Pollen,
    Cats,
}

impl Allergies {
    pub fn new(score: u32) -> Self {
        let mut score_map = HashMap::new();
        let mut power = 0;
        for allergen in [
            Allergen::Eggs,
            Allergen::Peanuts,
            Allergen::Shellfish,
            Allergen::Strawberries,
            Allergen::Tomatoes,
            Allergen::Chocolate,
            Allergen::Pollen,
            Allergen::Cats,
        ] {
            score_map.insert(power, allergen);
            power += 1;
        }

        Allergies { score, score_map }
    }

    pub fn is_allergic_to(&self, allergen: &Allergen) -> bool {
        self.allergies().contains(allergen)
    }

    pub fn allergies(&self) -> Vec<Allergen> {
        self.score_to_allergens(self.score)
    }

    fn score_to_allergens(&self, score: u32) -> Vec<Allergen> {
        if score == 0 {
            return Vec::new();
        }

        let mut results = Vec::new();
        
        for power in 0..8 {
            if (score >> power) & 1 == 1 {
                if let Some(&allergen) = self.score_map.get(&power) {
                    results.push(allergen);
                }
            }
        }
        
        results
    }
}