use std::collections::HashMap;

pub fn plants(diagram: &str, student: &str) -> Vec<&'static str> {
    let mut plants_map = HashMap::new();
    plants_map.insert('G', "grass");
    plants_map.insert('C', "clover");
    plants_map.insert('R', "radishes");
    plants_map.insert('V', "violets");

    let rows: Vec<&str> = diagram.split('\n').collect();
    let idx = name_index(student);
    let mut result = Vec::new();

    for row in rows {
        let chars: Vec<char> = row.chars().collect();
        let plant1 = chars[idx * 2];
        let plant2 = chars[idx * 2 + 1];
        result.push(*plants_map.get(&plant1).unwrap());  
        result.push(*plants_map.get(&plant2).unwrap());  
    }

    result
}

fn name_index(name: &str) -> usize {
    name.chars().next().unwrap().to_ascii_uppercase() as usize - 'A' as usize
}