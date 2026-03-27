pub type Tree(a) {
  Leaf
  Node(value: a, left: Tree(a), right: Tree(a))
}

type Crumb(a) {
  LeftCrumb(value: a, right: Tree(a))
  RightCrumb(value: a, left: Tree(a))
}

pub opaque type Zipper(a) {
  Zipper(focus: Tree(a), crumbs: List(Crumb(a)))
}

pub fn to_zipper(tree: Tree(a)) -> Zipper(a) {
  Zipper(tree, [])
}

pub fn to_tree(zipper: Zipper(a)) -> Tree(a) {
  case up(zipper) {
    Error(_) -> zipper.focus
    Ok(z) -> to_tree(z)
  }
}

pub fn value(zipper: Zipper(a)) -> Result(a, Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(v, _, _) -> Ok(v)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.crumbs {
    [] -> Error(Nil)
    [first, ..rest] -> case first {
      LeftCrumb(v, r) -> Zipper(Node(v, zipper.focus, r), rest) |> Ok
      RightCrumb(v, l) -> Zipper(Node(v, l, zipper.focus), rest) |> Ok
    }
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(v, l, r) -> Zipper(l, [LeftCrumb(v, r), ..zipper.crumbs]) |> Ok
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(v, l, r) -> Zipper(r, [RightCrumb(v, l), ..zipper.crumbs]) |> Ok
  }
}

pub fn set_value(zipper: Zipper(a), value: a) -> Zipper(a) {
  case zipper.focus {
    Leaf -> Node(value, Leaf, Leaf) |> Zipper(_, zipper.crumbs)
    Node(_, l, r) -> Node(value, l, r) |> Zipper(_, zipper.crumbs)
  }
}

pub fn set_left(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(v, l, r) -> Zipper(Node(v, tree, r), zipper.crumbs) |> Ok
  }
}

pub fn set_right(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(v, l, r) -> Zipper(Node(v, l, tree), zipper.crumbs) |> Ok
  }
}
