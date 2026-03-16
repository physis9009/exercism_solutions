import gleam/string

pub fn message(log_line: String) -> String {
  let split_result = string.split_once(log_line, ":")
  case split_result {
    Ok(result_tupple) -> string.trim(result_tupple.1)
    Error(_) -> "invalid log-line"
  }
}

pub fn log_level(log_line: String) -> String {
  let split_result = string.split_once(log_line, ":")
  case split_result {
    Ok(result_tupple) -> string.drop_start(result_tupple.0, 1) |> string.drop_end(1) |> string.lowercase()
    Error(_) -> "invalid log-line"
  }
}

pub fn reformat(log_line: String) -> String {
  let message = message(log_line)
  let wrapped_log_level = log_level(log_line) |> wrap_with_parentheses()

  string.join([message, wrapped_log_level], " ")
}

fn wrap_with_parentheses(log_level: String) -> String {
  string.append("(", log_level) |> string.append(")")
}