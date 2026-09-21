use std::collections::HashMap;

#[derive(Debug, PartialEq, Eq)]
pub struct Dna {
    strand: String,
    trans_map: HashMap<char, char>,
}

#[derive(Debug, PartialEq, Eq)]
pub struct Rna(String);

impl Dna {
    pub fn new(dna: &str) -> Result<Dna, usize> {
        let trans_map = HashMap::from([
            ('G', 'C'),
            ('C', 'G'),
            ('T', 'A'),
            ('A', 'U'),
        ]);
        match dna.find(|ch| !"ACGT".contains(ch)) {
            Some(index) => Err(index),
            None => Ok(Dna {
                strand: String::from(dna),
                trans_map,
            }),
        }
    }

    pub fn into_rna(self) -> Rna {
        Rna(self.strand
            .chars()
            .map(|ch| self.trans_map.get(&ch).unwrap())
            .copied()
            .collect())
    }
}

impl Rna {
    pub fn new(rna: &str) -> Result<Rna, usize> {
        match rna.find(|ch| !"ACGU".contains(ch)) {
            Some(index) => Err(index),
            None => Ok(Rna(String::from(rna))),
        }
    }
}
