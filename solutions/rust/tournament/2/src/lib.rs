use std::collections::HashMap;

pub fn tally(match_results: &str) -> String {
    let head = String::from("Team                           | MP |  W |  D |  L |  P");
    let mut result_map: HashMap<&str, Record> = HashMap::new();
    for result in match_results.lines() {
        let result_vec: Vec<&str> = result.split(";").collect();
        let h = result_vec[0];
        let a = result_vec[1];
        let o = result_vec[2];
        let update_h = match o {
            "win" => [1, 0, 0],
            "draw" => [0, 1, 0],
            "loss" => [0, 0, 1],
            _ => unreachable!(),
        };
        let update_a = match o {
            "win" => [0, 0, 1],
            "draw" => [0, 1, 0],
            "loss" => [1, 0, 0],
            _ => unreachable!(),
        };
        
        result_map.entry(h).or_insert(Record::new()).update(update_h);
        result_map.entry(a).or_insert(Record::new()).update(update_a);
    }

    let mut teams: Vec<(&str, &Record)> = result_map.iter().map(|(&k, v)| (k, v)).collect();

    teams.sort_by(|a, b| {
        b.1.p.cmp(&a.1.p)         
            .then_with(|| a.0.cmp(b.0)) 
    });
    
    let mut table: Vec<String> = Vec::with_capacity(teams.len() + 1);
    table.push(head);
    for (team, record) in teams {
        table.push(format!(
            "{:<30} | {:>2} | {:>2} | {:>2} | {:>2} | {:>2}",
            team, record.mp, record.w, record.d, record.l, record.p
        ));
    }
    
    table.join("\n")
}

struct Record {
    mp: usize,
    w: usize,
    d: usize,
    l: usize,
    p: u32,
}

impl Record {
    fn new() -> Self {
        Record {
            mp: 0,
            w: 0,
            d: 0,
            l: 0,
            p: 0,
        }
    }

    fn update(&mut self, result: [usize; 3]) {
        self.mp += 1;
        self.w += result[0];
        self.d += result[1];
        self.l += result[2];
        self.p += result[0] as u32 * 3 + result[1] as u32;
    }
}
