use std::collections::HashMap;

pub type Value = i32;
pub type Result = std::result::Result<(), Error>;

#[derive(Clone)]
struct Definition {
    body: Vec<String>,
    snapshot: HashMap<String, u64>,
    version: u64,
}

pub struct Forth {
    stack: Vec<Value>,
    vars: HashMap<String, Vec<Definition>>,
    next_version: u64,
}

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    DivisionByZero,
    StackUnderflow,
    UnknownWord,
    InvalidWord,
}

impl Forth {
    pub fn new() -> Forth {
        Forth {
            stack: Vec::new(),
            vars: HashMap::new(),
            next_version: 0,
        }
    }

    pub fn stack(&self) -> Vec<Value> {
        self.stack.clone()
    }

    pub fn eval(&mut self, input: &str) -> Result {
        let lowered = input.to_lowercase();
        let trimmed = lowered.trim();

        if trimmed.starts_with(':') {
            self.define(trimmed)
        } else {
            let tokens = self.expand_top(trimmed);
            for item in tokens {
                self.execute_token(&item)?;
            }
            Ok(())
        }
    }

    fn expand_top(&self, input: &str) -> Vec<String> {
        let mut result = Vec::new();
        let empty = HashMap::new();
        let mut stack: Vec<(String, std::rc::Rc<HashMap<String, u64>>)> = input
            .split_ascii_whitespace()
            .map(|s| (s.to_string(), std::rc::Rc::new(empty.clone())))
            .collect();
        stack.reverse();

        let mut steps = 0usize;
        const MAX_STEPS: usize = 10_000_000;

        while let Some((tok, snap)) = stack.pop() {
            steps += 1;
            if steps > MAX_STEPS {
                break;
            }
            if let Some(def) = self.lookup(&tok, &snap) {
                let def_snap = std::rc::Rc::new(def.snapshot.clone());
                let mut body_tokens: Vec<String> = def.body.clone();
                body_tokens.reverse();
                for t in body_tokens {
                    stack.push((t, def_snap.clone()));
                }
            } else {
                result.push(tok);
            }
        }
        result
    }

    fn lookup<'a>(
        &'a self,
        name: &str,
        snapshot: &HashMap<String, u64>,
    ) -> Option<&'a Definition> {
        let versions = self.vars.get(name)?;
        let version = match snapshot.get(name) {
            Some(&v) => v,
            None => versions.last()?.version,
        };
        versions.iter().find(|d| d.version == version)
    }

    fn execute_token(&mut self, item: &str) -> Result {
        if let Ok(num) = item.parse::<i32>() {
            self.stack.push(num);
            return Ok(());
        }

        match item {
            "dup" => {
                if let Some(&last) = self.stack.last() {
                    self.stack.push(last);
                    Ok(())
                } else {
                    Err(Error::StackUnderflow)
                }
            }
            "drop" => {
                if self.stack.pop().is_some() {
                    Ok(())
                } else {
                    Err(Error::StackUnderflow)
                }
            }
            "+" | "-" | "*" | "/" | "swap" | "over" => {
                let b = self.stack.pop().ok_or(Error::StackUnderflow)?;
                let a = self.stack.pop().ok_or(Error::StackUnderflow)?;
                match item {
                    "+" => self.stack.push(a + b),
                    "-" => self.stack.push(a - b),
                    "*" => self.stack.push(a * b),
                    "/" => {
                        if b == 0 {
                            return Err(Error::DivisionByZero);
                        }
                        self.stack.push(a / b);
                    }
                    "swap" => {
                        self.stack.push(b);
                        self.stack.push(a);
                    }
                    "over" => {
                        self.stack.push(a);
                        self.stack.push(b);
                        self.stack.push(a);
                    }
                    _ => unreachable!(),
                }
                Ok(())
            }
            _ => Err(Error::UnknownWord),
        }
    }

    fn define(&mut self, input: &str) -> Result {
        let tokens: Vec<&str> = input.split_ascii_whitespace().collect();

        if tokens.len() < 3 || tokens[0] != ":" || *tokens.last().unwrap() != ";" {
            return Err(Error::InvalidWord);
        }

        let name = tokens[1];
        if name.parse::<i32>().is_ok() {
            return Err(Error::InvalidWord);
        }

        let body_tokens = &tokens[2..tokens.len() - 1];

        let mut snapshot = HashMap::new();
        for &tok in body_tokens {
            if let Some(versions) = self.vars.get(tok) {
                if let Some(last) = versions.last() {
                    snapshot.insert(tok.to_string(), last.version);
                }
            }
        }

        let version = self.next_version;
        self.next_version += 1;

        let def = Definition {
            body: body_tokens.iter().map(|s| s.to_string()).collect(),
            snapshot,
            version,
        };

        self.vars.entry(name.to_string()).or_default().push(def);
        Ok(())
    }
}