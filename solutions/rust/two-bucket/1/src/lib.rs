use std::collections::HashMap;

#[derive(PartialEq, Eq, Debug, Clone, Copy)]
pub enum Bucket {
    One,
    Two,
}

#[derive(PartialEq, Eq, Debug, Clone, Copy)]
pub struct BucketStats {
    pub moves: u8,
    pub goal_bucket: Bucket,
    pub other_bucket: u8,
}

pub fn solve(
    capacity_1: u8,
    capacity_2: u8,
    goal: u8,
    start_bucket: &Bucket,
) -> Option<BucketStats> {
    let mut tried: HashMap<(u8, u8), Option<BucketStats>> = HashMap::new();
    
    let (init1, init2) = match start_bucket {
        Bucket::One => (capacity_1, 0),
        Bucket::Two => (0, capacity_2),
    };

    if init1 == goal || init2 == goal {
        let (goal_bucket, other_bucket) = if init1 == goal {
            (Bucket::One, init2)
        } else {
            (Bucket::Two, init1)
        };
        return Some(BucketStats { moves: 1, goal_bucket, other_bucket });
    }

    dfs(init1, init2, capacity_1, capacity_2, goal, start_bucket, &mut tried)
        .map(|mut stats| {
            stats.moves += 1; 
            stats
        })
}

fn dfs(
    l1: u8,
    l2: u8,
    cap1: u8,
    cap2: u8,
    goal: u8,
    start: &Bucket,
    tried: &mut HashMap<(u8, u8), Option<BucketStats>>,
) -> Option<BucketStats> {
    if l1 == goal {
        return Some(BucketStats {
            moves: 0,
            goal_bucket: Bucket::One,
            other_bucket: l2,
        });
    }
    if l2 == goal {
        return Some(BucketStats {
            moves: 0,
            goal_bucket: Bucket::Two,
            other_bucket: l1,
        });
    }

    match start {
        Bucket::One => {
            if l1 == 0 && l2 == cap2 {
                return None;
            }
        }
        Bucket::Two => {
            if l2 == 0 && l1 == cap1 {
                return None;
            }
        }
    }

    if let Some(cached) = tried.get(&(l1, l2)) {
        return cached.clone();
    }

    let mut nexts: Vec<(u8, u8)> = Vec::new();
    if l1 < cap1 { nexts.push((cap1, l2)); }
    if l2 < cap2 { nexts.push((l1, cap2)); }
    if l1 > 0 { nexts.push((0, l2)); }
    if l2 > 0 { nexts.push((l1, 0)); }
    if l1 > 0 && l2 < cap2 {
        let pour = l1.min(cap2 - l2);
        nexts.push((l1 - pour, l2 + pour));
    }
    if l2 > 0 && l1 < cap1 {
        let pour = l2.min(cap1 - l1);
        nexts.push((l1 + pour, l2 - pour));
    }

    let mut best: Option<BucketStats> = None;
    for (nl1, nl2) in nexts {
        if let Some(mut sub) = dfs(nl1, nl2, cap1, cap2, goal, start, tried) {
            sub.moves += 1;
            best = Some(match best {
                Some(b) if b.moves <= sub.moves => b,
                _ => sub,
            });
        }
    }

    tried.insert((l1, l2), best.clone());
    best
}