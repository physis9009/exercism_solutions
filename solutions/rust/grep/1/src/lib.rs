use anyhow::Error;
use std::fs;

#[derive(Debug)]
pub struct Flags<'a> {
    flags: &'a [&'a str],
}

impl<'a> Flags<'a> {
    pub fn new(flags: &'a [&'a str]) -> Self {
        Self { flags }
    }
}

pub fn grep(pattern: &str, flags: &Flags, files: &[&str]) -> Result<Vec<String>, Error> {
    let flags = flags.flags;
    let case_insensitive = flags.contains(&"-i");
    // let pattern = if case_insensitive {
    //     pattern.to_lowercase()
    // } else { pattern.to_string() };
    let mut result: Vec<String> = Vec::new();
        
    for &name in files.iter() {
        let bytes = fs::read(name)?;
        let mut content = str::from_utf8(&bytes)?;
        // if case_insensitive { content = content.to_lowercase(); }

        if flags.contains(&"-l") {
            if content.contains(pattern) { result.push(name.to_string()); }
        } else {
            let mut lines = content.lines().enumerate();
            let mut filtered = lines.filter(|&(_, l)| {
                match (flags.contains(&"-v"), flags.contains(&"-x")) {
                    (true, true) => if case_insensitive {
                        l.to_lowercase() != pattern.to_lowercase()
                    } else { l != pattern },
                    (true, false) => if case_insensitive {
                        !l.to_lowercase().contains(pattern.to_lowercase().as_str())
                    } else { !l.contains(pattern) },
                    (false, true) => if case_insensitive {
                        l.to_lowercase() == pattern.to_lowercase()
                    } else { l == pattern },
                    (false, false) => if case_insensitive {
                        l.to_lowercase().contains(pattern.to_lowercase().as_str())
                    } else { l.contains(pattern) },
                }
            });
            for (i, line) in filtered {
                if flags.contains(&"-n") {
                    if files.len() == 1 {
                        result.push(format!("{}:{}", i + 1, line));
                    } else { result.push(format!("{}:{}:{}", name, i + 1, line)); }
                } else {
                    if files.len() == 1 {
                        result.push(format!("{}", line)); 
                    } else { result.push(format!("{}:{}", name, line)); }
                }
            }
        }
    }

    Ok(result)
}
