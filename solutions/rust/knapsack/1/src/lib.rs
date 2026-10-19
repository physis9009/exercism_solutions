#[derive(Debug)]
pub struct Item {
    pub weight: u32,
    pub value: u32,
}

pub fn maximum_value(max_weight: u32, items: &[Item]) -> u32 {
    if max_weight == 0 || items.is_empty() { return 0; }

    let last = items.last().unwrap();
    let bigger_without_last = maximum_value(max_weight, &items[..(items.len() - 1)]);
    let smaller_plus_last = if max_weight >= last.weight {
        maximum_value(max_weight - last.weight, &items[..(items.len() - 1)]) + last.value
    } else { 0 };
    
    bigger_without_last.max(smaller_plus_last)
}
