use std::collections::HashMap;

pub fn recite(start_bottles: u32, take_down: u32) -> String {
    let num_words = vec![
        "no", "One", "Two", "Three",
        "Four", "Five", "Six",
        "Seven", "Eight", "Nine", "Ten",
    ];
    let mut num = 0_u32; 
    
    let mut num_map = HashMap::new();
    for n in num_words {
        num_map.insert(num, n);
        num += 1;
    }
    
    let verse1 = " green bottles hanging on the wall,\n";
    let verse1_singular = " green bottle hanging on the wall,\n";
    let verse2 = "And if one green bottle should accidentally fall,\n";
    let verse3 = "There'll be ";
    let verse4 = " green bottles hanging on the wall.\n\n";
    let verse34_singular = "There'll be one green bottle hanging on the wall.\n\n";
    
    let mut verse_num = start_bottles;
    let mut count = take_down;
    let mut result = String::new(); 

    while count > 0 {
        let current = num_map.get(&verse_num).copied().unwrap_or(""); 
        let next = if verse_num > 0 {
            num_map.get(&(verse_num - 1)).copied().unwrap_or("").to_ascii_lowercase()
        } else {
            String::from("no")
        };
        
        if verse_num != 1 {
            result.push_str(&format!(
                "{}{}{}{}{}",
                current, verse1,
                current, verse1, verse2
            ));
        } else {
            result.push_str(&format!(
                "{}{}{}{}{}",
                current, verse1_singular,
                current, verse1_singular, verse2
            ));
        }

        
        if verse_num != 1 { 
            if verse_num != 2 {
                result.push_str(&format!(
                    "{}{}{}",
                    verse3, next, verse4
                ));
            } else {
                result.push_str(&format!(
                    "{}",
                    verse34_singular
                ));
            }
        } else {
            result.push_str("There'll be no green bottles hanging on the wall.");
        }

        verse_num -= 1;
        count -= 1;
    }

    result
}