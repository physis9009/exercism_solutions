pub fn egg_count(number: Int) -> Int {
  count_1bits(<<number:size(32)>>, 0)
}

fn count_1bits(number: BitArray, acc: Int) -> Int {
  case number {
    <<1:1, rest:bits>> -> count_1bits(rest, acc + 1)
    <<0:1, rest:bits>> -> count_1bits(rest, acc)
    <<>> -> acc
    _ -> acc
  }
}