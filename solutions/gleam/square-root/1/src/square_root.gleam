pub fn square_root(radicand: Int) -> Int {
  binary_search(1, radicand, radicand)
}

fn binary_search(left: Int, right: Int, radicand: Int) -> Int {
  case left + {right - left} / 2 {
    m if m * m == radicand -> m
    m if m * m < radicand -> binary_search(m + 1, right, radicand)
    m -> binary_search(left, m - 1, radicand)
  }
}