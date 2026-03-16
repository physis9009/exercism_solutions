import simplifile
import gleam/string
import gleam/list

pub fn read_emails(path: String) -> Result(List(String), Nil) {
  case simplifile.read(path) {
    Ok(text) -> Ok(string.split(text, "\n") |> list.filter(fn(email) {email != ""}))
    Error(_) -> Error(Nil)
  }
}

pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  case simplifile.create_file(path) {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(Nil)
  }
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
  case simplifile.append(path, email <> "\n") {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(Nil)
  }
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
  case read_emails(emails_path) {
    Error(Nil) -> Error(Nil)
    Ok(emails) -> {
      case create_log_file(log_path) {
        Error(Nil) -> Error(Nil)
        Ok(Nil) -> {
          let log_results = list.map(emails, fn(email) {
            case send_email(email) {
              Ok(Nil) -> case log_sent_email(log_path, email) {
                Ok(Nil) -> Ok(Nil)
                Error(Nil) -> Error(Nil)
              }
              Error(Nil) -> Ok(Nil)
            }
          })

          case list.any(log_results, fn(result) {result == Error(Nil)}) {
            True -> Error(Nil)
            False -> Ok(Nil)
          }
        }
      }
    }
  }
}