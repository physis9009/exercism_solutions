pub fn brackets_are_balanced(string: &str) -> bool {
    let filtered = string
        .chars()
        .filter(|&char| "()[]{}".contains(char));
    let mut stack: Vec<char> = Vec::new();

    for char in filtered {
        if !stack.is_empty() {
            if "([{".contains(char) {
                stack.push(char);
            } else if let Some(&last) = stack.last() {
                if (last == '(' && char == ')') || (last == '[' && char == ']') || (last == '{' && char == '}') {
                    stack.pop();
                } else { return false; }
            } else { return false; }
        } else { stack.push(char); }
    }

    stack.is_empty()
}
