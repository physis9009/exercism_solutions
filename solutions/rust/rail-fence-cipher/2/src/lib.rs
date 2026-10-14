pub struct RailFence(usize);

impl RailFence {
    pub fn new(rails: u32) -> RailFence {
        RailFence(rails as usize)
    }

    pub fn encode(&self, text: &str) -> String {
        let mut rails: Vec<Vec<char>> = (0..(self.0)).map(|_| Vec::new()).collect(); 
        let mut offset: i64 = -1;
        let mut current: i64 = 0;
        let i_last = (self.0 - 1) as i64;
        
        for ch in text.chars() {
            rails[current as usize].push(ch);
            if current == 0 || current == i_last { offset *= -1; }
            current += offset;
        }
        
        rails.into_iter().flatten().collect::<String>()
    }

    pub fn decode(&self, cipher: &str) -> String {
        let char_vec: Vec<char> = cipher.chars().collect();
        let total = char_vec.len();
        
        let mut rails: Vec<Vec<usize>> = (0..(self.0)).map(|_| Vec::new()).collect(); 
        let mut offset: i64 = -1;
        let mut current: i64 = 0;
        let i_last = (self.0 - 1) as i64;
        
        for i in 0..total {
            rails[current as usize].push(i);
            if current == 0 || current == i_last { offset *= -1; }
            current += offset;
        }
        
        let mut zipped: Vec<_> = rails
            .into_iter()
            .flatten()
            .zip(char_vec)
            .collect();
        zipped.sort_by_key(|a| a.0);

        zipped.into_iter().map(|(_, ch)| ch).collect::<String>()
    }
}
