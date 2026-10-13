/// Yields each item of a and then each item of b
pub fn append<I, J>(mut a: I, mut b: J) -> impl Iterator<Item = I::Item>
where
    I: Iterator + 'static,
    J: Iterator<Item = I::Item> + 'static,
{
    std::iter::from_fn(move || {
        match a.next() {
            Some(i) => Some(i),
            None => b.next(),
        }
    })
}

/// Combines all items in all nested iterators inside into one flattened iterator
pub fn concat<I>(mut nested_iter: I) -> impl Iterator<Item = <I::Item as Iterator>::Item>
where
    I: Iterator + 'static,
    I::Item: Iterator + 'static,
{
    let mut current = nested_iter.next();
    std::iter::from_fn(move || {
        loop {
            match current.as_mut() {
                None => return None,
                Some(iter) => {
                    match iter.next() {
                        Some(i) => return Some(i),
                        None => current = nested_iter.next(),
                    }
                }
            }
        }
    })
}

pub fn filter<I, F>(mut iter: I, predicate: F) -> impl Iterator<Item = I::Item>
where
    I: Iterator + 'static,
    F: Fn(&I::Item) -> bool + 'static,
{
    std::iter::from_fn(move || {
        loop {
            match iter.next() {
                Some(item) if predicate(&item) => return Some(item),
                Some(_) => continue,   
                None => return None,   
            }
        }
    })
}

pub fn length<I: Iterator>(iter: I) -> usize {
    let mut count = 0;
    for _ in iter {
        count += 1;
    }
    count
}

/// Returns an iterator of the results of applying `function(item)` on all iter items
pub fn map<I, F, U>(mut iter: I, function: F) -> impl Iterator<Item = U>
where
    I: Iterator + 'static,
    F: Fn(I::Item) -> U + 'static,
{
    std::iter::from_fn(move || { iter.next().map(&function) })
}

pub fn foldl<I, F, U>(iter: I, initial: U, function: F) -> U
where
    I: Iterator,
    F: Fn(U, I::Item) -> U,
{
    let mut result = initial;
    for item in iter {
        result = function(result, item);
    }
    result
}

pub fn foldr<I, F, U>(iter: I, initial: U, function: F) -> U
where
    I: DoubleEndedIterator,
    F: Fn(U, I::Item) -> U,
{
    let reversed = reverse(iter);
    foldl(reversed, initial, function)
}

/// Returns an iterator with all the original items, but in reverse order
pub fn reverse<I: DoubleEndedIterator>(mut iter: I) -> impl Iterator<Item = I::Item> {
    std::iter::from_fn(move || iter.next_back())
}
