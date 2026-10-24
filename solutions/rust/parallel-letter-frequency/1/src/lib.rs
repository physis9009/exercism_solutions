use std::collections::HashMap;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    if input.is_empty() || worker_count == 0 {
        return HashMap::new();
    }

    let total = input.len();
    let chunk_size = total.div_ceil(worker_count);

    thread::scope(|s| {
        let mut handles = Vec::new();

        for chunk in input.chunks(chunk_size) {
            handles.push(s.spawn(move || {
                let mut current: HashMap<char, usize> = HashMap::new();
                for line in chunk {
                    for ch in line.chars() {
                        if ch.is_whitespace() || ch.is_ascii_digit() || ch.is_ascii_punctuation() { continue; }
                        let lowercased = ch.to_ascii_lowercase();
                        current.entry(lowercased).and_modify(|count| *count += 1).or_insert(1);
                    }
                }
                current
            }));
        }

        let mut result: HashMap<char, usize> = HashMap::new();
        for handle in handles {
            for (k, v) in handle.join().unwrap() {
                result.entry(k).and_modify(|count| *count += v).or_insert(v);
            }
        }
        
        result
    })
}