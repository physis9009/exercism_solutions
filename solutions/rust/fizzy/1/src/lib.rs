use std::ops::Rem;

pub struct Matcher<T> {
    matcher: Box<dyn Fn(T) -> bool>,
    subs: String,
}

impl<T: 'static> Matcher<T> {
    pub fn new<F, S>(matcher: F, subs: S) -> Matcher<T>
    where
        F: Fn(T) -> bool + 'static,
        S: ToString,
    {
        Matcher { matcher: Box::new(matcher), subs: subs.to_string() }
    }
}

pub struct Fizzy<T> {
    matchers: Vec<Matcher<T>>,
}

impl<T: ToString + Copy + 'static> Fizzy<T> {
    pub fn new() -> Self {
        Self { matchers: Vec::new() }
    }

    #[must_use]
    pub fn add_matcher(mut self, matcher: Matcher<T>) -> Self {
        self.matchers.push(matcher);
        self
    }

    pub fn apply<I>(self, iter: I) -> impl Iterator<Item = String>
    where
        I: Iterator<Item = T>,
    {
        iter.map(move |i| {
            let s: String = self.matchers.iter()
                .filter(|m| (m.matcher)(i))
                .map(|m| m.subs.clone())
                .collect();
            if s.is_empty() { i.to_string() } else { s }
        })
    }
}

pub fn fizz_buzz<T>() -> Fizzy<T>
where
    T: Rem<Output = T> + PartialEq + From<u8> + Copy + ToString + 'static,
{
    Fizzy::new()
        .add_matcher(Matcher::new(|n: T| n % T::from(3u8) == T::from(0u8), "fizz"))
        .add_matcher(Matcher::new(|n: T| n % T::from(5u8) == T::from(0u8), "buzz"))
}