pub fn build_proverb(list: &[&str]) -> String {
    let mut rhyme = String::new();
    let len = list.len();
    if len == 0 { return rhyme; }
    
    let fragment1 = "For want of a ";
    let fragment2 = " the ";
    let fragment3 = " was lost.\n";
    let last = "And all for the want of a ";
    for i in 0..(len - 1) {
        rhyme.push_str(fragment1);
        rhyme.push_str(list[i]);
        rhyme.push_str(fragment2);
        rhyme.push_str(list[i + 1]);
        rhyme.push_str(fragment3);
    }

    rhyme.push_str(last);
    rhyme.push_str(list[0]);
    rhyme.push('.');

    rhyme
}
