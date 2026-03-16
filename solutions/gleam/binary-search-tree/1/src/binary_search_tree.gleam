import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn to_tree(data: List(Int)) -> Tree {
  list.fold(data, Nil, insert_loop)
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  to_tree(data) |> sort_loop
}

fn insert_loop(tree: Tree, value: Int) -> Tree {
  case tree {
    Nil -> Node(value, Nil, Nil)
    Node(d, l, r) -> case value <= d {
      True -> Node(d, insert_loop(l, value), r)
      False -> Node(d, l, insert_loop(r, value))
    }
  }
}

fn sort_loop(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(d, l, r) -> [sort_loop(l), [d], sort_loop(r)] |> list.flatten
  }
}