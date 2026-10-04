use std::collections::HashMap;
use std::sync::LazyLock;

static MAP: LazyLock<HashMap<&str, &str>> = LazyLock::new(|| {
    HashMap::from([
        ("AUG", "Methionine"), ("UUU", "Phenylalanine"), ("UUC", "Phenylalanine"),
        ("UUA", "Leucine"),    ("UUG", "Leucine"),       ("UCU", "Serine"),
        ("UCC", "Serine"),     ("UCA", "Serine"),        ("UCG", "Serine"),
        ("UAU", "Tyrosine"),   ("UAC", "Tyrosine"),      ("UGU", "Cysteine"),
        ("UGC", "Cysteine"),   ("UGG", "Tryptophan"),    ("UAA", "STOP"),
        ("UAG", "STOP"),       ("UGA", "STOP"),
    ])
});

pub fn translate(rna: &str) -> Option<Vec<&'static str>> {
    let mut protein = Vec::new();
    let bytes = rna.as_bytes();

    let mut iter = rna.as_bytes().chunks_exact(3);
    for chunk in &mut iter {
        let codon = std::str::from_utf8(chunk).ok()?;
        let aa = MAP.get(codon)?;
        if *aa == "STOP" {
            return Some(protein);  
        }
        protein.push(*aa);
    }

    if !iter.remainder().is_empty() {
        return None;
    }

    Some(protein)
}