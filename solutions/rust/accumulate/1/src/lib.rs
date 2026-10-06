pub fn map<T, U, F>(input: Vec<T>, mut function: F) -> Vec<U> 
where
    F: FnMut(T) -> U,
{
    let mut outcome = Vec::new();
    for n in input {
        outcome.push(function(n));
    }
    outcome
}
