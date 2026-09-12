use std::collections::BTreeMap;

pub fn transform(h: &BTreeMap<i32, Vec<char>>) -> BTreeMap<char, i32> {
    let mut transformed = BTreeMap::new();
    for (&value, letters) in h {
        for letter in letters {
            transformed.insert(letter.to_ascii_lowercase(), value);
        }
    }
    
    transformed
}
