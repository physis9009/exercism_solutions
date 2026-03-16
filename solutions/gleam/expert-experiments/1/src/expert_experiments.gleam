import gleam/result

pub fn with_retry(experiment: fn() -> Result(t, e)) -> Result(t, e) {
  case experiment() {
    Error(_) -> experiment()
    Ok(t) -> Ok(t)
  }
}

pub fn record_timing(
  time_logger: fn() -> Nil,
  experiment: fn() -> Result(t, e),
) -> Result(t, e) {
  time_logger()
  case experiment() {
    result -> {
      time_logger()
      result
    }
  }
}

pub fn run_experiment(
  name: String,
  setup: fn() -> Result(t, e),
  action: fn(t) -> Result(u, e),
  record: fn(t, u) -> Result(v, e),
) -> Result(#(String, v), e) {
  let experiment_result = {
    use a <- result.try(setup())
    use b <- result.try(action(a))
    record(a, b)
  }

  case experiment_result {
    Ok(v) -> Ok(#(name, v))
    Error(e) -> Error(e)
  }
}