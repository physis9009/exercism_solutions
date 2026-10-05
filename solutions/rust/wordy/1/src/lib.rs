pub fn answer(command: &str) -> Option<i32> {
    let expr = command.strip_prefix("What is ")?
        .strip_suffix('?')?;
    let mut expr_iter = expr.split_whitespace().peekable();

    let mut stack: Vec<String> = Vec::new();

    stack.push(expr_iter.next()?.to_string());

    let mut skip_operand = false;

    while let Some(cur) = expr_iter.next() {
        if skip_operand {
            skip_operand = false;
            continue;
        }

        if let Some(&next) = expr_iter.peek() {
            match cur {
                "plus" => {
                    next.parse::<i32>().ok()?;
                    let result = stack.pop()?.parse::<i32>().ok()?
                        .checked_add(next.parse().ok()?)?;
                    stack.push(result.to_string());
                    skip_operand = true; 
                }
                "minus" => {
                    next.parse::<i32>().ok()?;
                    let result = stack.pop()?.parse::<i32>().ok()?
                        .checked_sub(next.parse().ok()?)?;
                    stack.push(result.to_string());
                    skip_operand = true;
                }
                "multiplied" | "divided" => stack.push(cur.to_string()),
                "by" => {
                    match stack.pop()?.as_str() {
                        "multiplied" => {
                            next.parse::<i32>().ok()?;
                            let result = stack.pop()?.parse::<i32>().ok()?
                                .checked_mul(next.parse().ok()?)?;
                            stack.push(result.to_string());
                            skip_operand = true;
                        }
                        "divided" => {
                            next.parse::<i32>().ok()?;
                            let result = stack.pop()?.parse::<i32>().ok()?
                                .checked_div(next.parse().ok()?)?;
                            stack.push(result.to_string());
                            skip_operand = true;
                        }
                        _ => return None,
                    }
                }
                _ => return None, 
            }
        } else { return None; }
    }

    stack.pop()?.parse().ok()
}