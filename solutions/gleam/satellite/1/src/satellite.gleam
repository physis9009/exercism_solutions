import gleam/bool
import gleam/list
import gleam/set

pub type Tree(a) {
  Nil
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Error {
  DifferentLengths
  DifferentItems
  NonUniqueItems
}

pub fn tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  use <- bool.guard(list.length(inorder) != list.length(preorder), Error(DifferentLengths))
  use <- bool.guard(set.from_list(inorder) != set.from_list(preorder), Error(DifferentItems))
  use <- bool.guard(list.unique(inorder) != inorder || list.unique(preorder) != preorder, Error(NonUniqueItems))
  tree_loop(inorder, preorder) |> Ok
}

fn seperate_inorder(inorder: List(a), root: a, acc: #(List(a), List(a))) -> #(List(a), List(a)) {
  case inorder {
    [first, ..rest] if first == root -> #(acc.0, rest)
    [first, ..rest] if first != root -> seperate_inorder(rest, root, #(list.append(acc.0, [first]), acc.1))
    _ -> acc
  }
}

fn seperate_preorder(preorder: List(a), seperated: #(List(a), List(a))) -> #(List(a), List(a)) {
  #(
    list.filter(preorder, fn(i) {list.contains(seperated.0, i)}),
    list.filter(preorder, fn(i) {list.contains(seperated.1, i)})
  )
}

fn tree_loop(inorder: List(a), preorder: List(a)) -> Tree(a) {
  case preorder {
    [] -> Nil
    [first, ..] -> {
      let in_tuple = seperate_inorder(inorder, first, #([], []))
      let pre_tuple = seperate_preorder(preorder, in_tuple)
      Node(first, tree_loop(in_tuple.0, pre_tuple.0), tree_loop(in_tuple.1, pre_tuple.1))
    }
  }
} 