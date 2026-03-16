import gleam/list
import gleam/bit_array

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0b00
    Cytosine -> 0b01
    Guanine -> 0b10
    Thymine -> 0b11
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0b00 -> Ok(Adenine)
    0b01 -> Ok(Cytosine)
    0b10 -> Ok(Guanine)
    0b11 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  list.map(dna, fn(nuc) {encode_nucleotide(nuc)}) |> list_to_bitarray(<<>>)
}

fn list_to_bitarray(list: List(Int), acc: BitArray) -> BitArray {
  case list {
    [] -> acc
    [first, ..rest] -> list_to_bitarray(rest, bit_array.append(acc, <<first:2>>))
  }
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  let result_list = split_2bits_list(dna, []) |> list.map(fn(item) {decode_nucleotide(item)})
  |> list.map(fn(item) {
    let assert Ok(nuc) = item
    nuc
  }) |> list.reverse

  case bit_array.bit_size(dna) % 2 {
    0 -> case result_list {
      [_, .._] -> Ok(result_list)
      [] -> Error(Nil)
    }
    _ -> Error(Nil)
  }
  
}

fn split_2bits_list(dna: BitArray, acc: List(Int)) -> List(Int) {
  case dna {
    <<nuc:2, rest:bits>> -> split_2bits_list(rest, [nuc, ..acc])
    <<>> -> acc
    _ -> acc
  }
}