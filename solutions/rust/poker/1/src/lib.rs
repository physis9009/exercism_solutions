use std::collections::HashSet;

pub fn winning_hands<'a>(hands: &[&'a str]) -> Vec<&'a str> {
    let ranked: Vec<(usize, (u8, Vec<u8>))> = hands
        .iter()
        .enumerate()
        .map(|(i, hand)| (i, rank_hand(hand)))
        .collect();

    let best = ranked.iter().map(|(_, r)| r.clone()).max().unwrap();

    ranked
        .into_iter()
        .filter(|(_, r)| *r == best)
        .map(|(i, _)| hands[i])
        .collect()
}

fn rank_hand(hand: &str) -> (u8, Vec<u8>) {
    let mut cards: Vec<(u8, char)> = hand
        .split_whitespace()
        .map(|s| {
            let (rank_str, suit_ch) = s.split_at(s.len() - 1);
            let rank = match rank_str {
                "J" => 11,
                "Q" => 12,
                "K" => 13,
                "A" => 14,
                "10" => 10,
                _ => rank_str.parse::<u8>().unwrap(),
            };
            let suit = suit_ch.chars().next().unwrap();
            (rank, suit)
        })
        .collect();

    cards.sort_by_key(|&(r, _)| r);
    let ranks: Vec<u8> = cards.iter().map(|&(r, _)| r).collect();
    let suits: Vec<char> = cards.iter().map(|&(_, s)| s).collect();
    let is_flush = suits.iter().all(|&s| s == suits[0]);

    let is_straight = {
        let mut uniq = ranks.clone();
        uniq.dedup();
        uniq.len() == 5
            && (uniq.windows(2).all(|w| w[1] - w[0] == 1)
                || uniq == [2, 3, 4, 5, 14])
    };
    let straight_high = if ranks == [2, 3, 4, 5, 14] {
        5
    } else {
        *ranks.last().unwrap()
    };

    let mut counts: Vec<(u8, u8)> = Vec::new();
    for &r in &ranks {
        match counts.iter_mut().find(|(rr, _)| *rr == r) {
            Some((_, c)) => *c += 1,
            None => counts.push((r, 1)),
        }
    }
    counts.sort_by(|a, b| b.1.cmp(&a.1).then(b.0.cmp(&a.0)));
    let pattern: Vec<u8> = counts.iter().map(|&(_, c)| c).collect();
    let ordered: Vec<u8> = counts.iter().map(|&(r, _)| r).collect();
    let desc: Vec<u8> = ranks.iter().rev().cloned().collect();

    if is_straight && is_flush {
        if straight_high == 14 {
            (9, vec![14])
        } else {
            (8, vec![straight_high])
        }
    } else if pattern == [4, 1] {
        (7, ordered)
    } else if pattern == [3, 2] {
        (6, ordered)
    } else if is_flush {
        (5, desc)
    } else if is_straight {
        (4, vec![straight_high])
    } else if pattern == [3, 1, 1] {
        (3, ordered)
    } else if pattern == [2, 2, 1] {
        (2, ordered)
    } else if pattern == [2, 1, 1, 1] {
        (1, ordered)
    } else {
        (0, desc)
    }
}