pub fn find(array: &[i32], key: i32) -> Option<usize> {
    bi_search(array, 0, array.len(), key)
}

fn bi_search(arr: &[i32], start: usize, end: usize, key: i32) -> Option<usize> {
    if start >= end { return None; }
    let half = start + (end - start) / 2;

    match arr[half] {
        n if n > key => bi_search(arr, start, half, key),
        n if n < key => bi_search(arr, half + 1, end, key),
        _ => Some(half),
    }
}