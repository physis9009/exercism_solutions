import gleam/list

pub opaque type Set(t) {
  Set(List(t))
}

pub fn new(members: List(t)) -> Set(t) {
  Set(members)
}

pub fn is_empty(set: Set(t)) -> Bool {
  let Set(l) = set
  list.is_empty(l)
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  let Set(l) = set
  list.contains(l, member)
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  let Set(l1) = first
  let Set(l2) = second
  list.all(l1, fn(a) {list.contains(l2, a)})
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  let Set(l1) = first
  let Set(l2) = second
  !list.any(l2, fn(a) {list.contains(l1, a)})
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  let Set(l1) = first
  let Set(l2) = second
  {list.length(l1) == list.length(l2)} && is_subset(first, second)
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  let Set(l) = set
  list.prepend(l, member) |> list.unique |> Set
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  let Set(l1) = first
  let Set(l2) = second
  list.filter(l1, fn(a) {list.contains(l2, a)}) |> list.unique |> Set
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  let Set(l1) = first
  let Set(l2) = second
  list.filter(l1, fn(a) {!list.contains(l2, a)}) |> list.unique |> Set
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  let Set(l1) = first
  let Set(l2) = second
  list.append(l1, l2) |> list.unique |> Set
}
