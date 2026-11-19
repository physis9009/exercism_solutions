use std::collections::HashMap;

pub fn chain(input: &[(u8, u8)]) -> Option<Vec<(u8, u8)>> {
    if input.is_empty() { return Some(Vec::new()); }
    
    let mut adj: HashMap<u8, Vec<usize>> = HashMap::new();
    let mut deg: HashMap<u8, usize> = HashMap::new();
    for i in 0..input.len() {
        if input[i].0 == input[i].1 {
            adj.entry(input[i].0).and_modify(|a| { a.push(i); }).or_insert(vec![i]);
            deg.entry(input[i].0).and_modify(|d| { *d += 2; }).or_insert(2);
        } else {
            adj.entry(input[i].0).and_modify(|a| { a.push(i); }).or_insert(vec![i]);
            deg.entry(input[i].0).and_modify(|d| { *d += 1; }).or_insert(1);
            adj.entry(input[i].1).and_modify(|a| { a.push(i); }).or_insert(vec![i]);
            deg.entry(input[i].1).and_modify(|d| { *d += 1; }).or_insert(1);
        }
    }

    if deg.values().any(|d| !d.is_multiple_of(2)) { return None; }

    let mut used = vec![false; input.len()];
    let mut path = vec![input[0].0];
    hierholzer(input, &mut adj, &mut path, &mut used);

    let track: Vec<(u8, u8)> = path.windows(2)
        .map(|pair| (pair[0], pair[1]))
        .collect();
    if track.len() == input.len() {
        Some(track)
    } else { None }
}

fn hierholzer(input: &[(u8, u8)], adj: &mut HashMap<u8, Vec<usize>>, path: &mut Vec<u8>, used: &mut Vec<bool>) {
    if let Some(&curr) = path.last() {
        if let Some(i_edges) = adj.get_mut(&curr) {
            if let Some(i_edge) = i_edges.pop() {
                if used[i_edge] { 
                    hierholzer(input, adj, path, used); 
                } else {
                    let (start, end) = input[i_edge];
                    let next = if curr == start { end } else { start };
                    path.push(next);
                    used[i_edge] = true;
                    hierholzer(input, adj, path, used);
                }
            } else { return; }
        }
    }
}