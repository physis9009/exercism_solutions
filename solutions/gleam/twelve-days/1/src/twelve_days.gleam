import gleam/list
import gleam/string

const words = [#(2, "second", "two Turtle Doves, "), #(3, "third", "three French Hens, "), #(4, "fourth", "four Calling Birds, "), #(5, "fifth", "five Gold Rings, "), #(6, "sixth", "six Geese-a-Laying, "), #(7, "seventh", "seven Swans-a-Swimming, "), #(8, "eighth", "eight Maids-a-Milking, "), #(9, "ninth", "nine Ladies Dancing, "), #(10, "tenth", "ten Lords-a-Leaping, "), #(11, "eleventh", "eleven Pipers Piping, "), #(12, "twelfth", "twelve Drummers Drumming, ")]

pub fn verse(number: Int) -> String {
  fill_verse(number, words, "", "and a Partridge in a Pear Tree.")
}

fn fill_verse(number: Int, words_list: List(#(Int, String, String)), first_part: String, second_part: String) -> String {
  case number, words_list {
    1, _ -> "On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree."
    n, [first, ..rest] if n > first.0 - 1 -> fill_verse(n, rest, "On the " <> first.1 <> " day of Christmas my true love gave to me: ", first.2 <> second_part)
    _, _ -> first_part <> second_part
  }
}

pub fn lyrics(from starting_verse: Int, to ending_verse: Int) -> String {
  full_song(1, []) |> list.drop(starting_verse - 1) |> list.take(ending_verse - starting_verse + 1) |> string.join("\n")
}

fn full_song(number: Int, acc: List(String)) -> List(String) {
  case number < 13 {
    True -> full_song(number + 1, list.append(acc, [verse(number)]))
    False -> acc
  }
}