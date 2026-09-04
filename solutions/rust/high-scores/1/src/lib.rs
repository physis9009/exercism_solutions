#[derive(Debug)]
pub struct HighScores {
    scores: Vec<u32>,
    stack: Vec<u32>,
}

impl HighScores {
    pub fn new(scores: &[u32]) -> Self {
        let mut stack = scores.to_vec();  
        stack.sort_unstable_by(|a, b| b.cmp(a)); 
        
        HighScores {
            scores: scores.to_vec(),
            stack,
        }
    }

    pub fn scores(&self) -> &[u32] {
        self.scores.as_slice()
    }

    pub fn latest(&self) -> Option<u32> {
        self.scores.last().copied()
    }

    pub fn personal_best(&self) -> Option<u32> {
        self.stack.first().copied()
    }

    pub fn personal_top_three(&self) -> Vec<u32> {
        self.stack.iter().take(3).copied().collect()
    }
}
