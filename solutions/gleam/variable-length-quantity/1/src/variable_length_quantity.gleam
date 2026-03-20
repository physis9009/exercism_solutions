import gleam/list
import gleam/result
import gleam/bit_array

pub type Error {
  IncompleteSequence
}

pub fn encode(integers: List(Int)) -> BitArray {
  list.map(integers, fn(a) {division_loop(a, [])})
  |> list.map(fn(a) {to_bitarray(a, <<>>)})
  |> list.fold(<<>>, fn(acc, a) {<<acc:bits, a:bits>>})
}

fn division_loop(num: Int, acc: List(Int)) -> List(Int) {
  case num >= 128 {
    True -> division_loop(num / 128, list.prepend(acc, num % 128))
    False -> list.prepend(acc, num % 128)
  }
}

fn to_bitarray(nums: List(Int), acc: BitArray) -> BitArray {
  case nums {
    [first, second, ..rest] -> to_bitarray([second, ..rest], <<acc:bits, 1:size(1), first:size(7)>>)
    [last] -> to_bitarray([], <<acc:bits, 0:size(1), last:size(7)>>)
    [] -> acc
  }
}

pub fn decode(string: BitArray) -> Result(List(Int), Error) {
  use ba_list <- result.map(seperate_loop(string, <<>>, []))
  list.map(ba_list, fn(bitarray) {
    let ba_size = bit_array.bit_size(bitarray)
    let assert <<x:size(ba_size)>> = bitarray
    x
  })
}

fn seperate_loop(bitarray: BitArray, num: BitArray, acc: List(BitArray)) -> Result(List(BitArray), Error) {
  case bitarray {
    <<1:size(1), first:size(7), next:size(8), rest:bits>> -> seperate_loop(<<next:size(8), rest:bits>>, <<num:bits, first:size(7)>>, acc)
    <<0:size(1), first:size(7), rest:bits>> -> seperate_loop(rest, <<>>, list.append(acc, [<<num:bits, first:size(7)>>]))
    <<1:size(1), _:size(7)>> -> Error(IncompleteSequence)
    <<>> -> Ok(acc)
    _ -> Error(IncompleteSequence)
  }
}