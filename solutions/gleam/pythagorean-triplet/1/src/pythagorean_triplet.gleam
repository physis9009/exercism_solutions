import gleam/int
import gleam/float
import gleam/list
import gleam/order.{type Order, Gt, Lt, Eq}

pub type Triplet {
  Triplet(Int, Int, Int)
}

pub fn triplets_with_sum(sum: Int) -> List(Triplet) {
  case sum % 2 == 0 {
    False -> []
    True -> possible_m_n(2, 1, sqr(sum / 2), sum / 2, [])
    |> list.filter(fn(a) {are_coprime(a.1, a.0, 2) && opposite_parity(a.0, a.1)})
    |> add_k(sum / 2, [])
    |> list.map(fn(a) {
      let p = a.0 * {a.1 * a.1 - a.2 * a.2}
      let q = 2 * a.0 * a.1 * a.2
      let y = a.0 * {a.1 * a.1 + a.2 * a.2}
      case p < q {
        True -> Triplet(p, q, y)
        False -> Triplet(q, p, y)
      }
    })
    |> list.sort(triplet_compare)
  }
}

fn are_coprime(m: Int, n: Int, divisor: Int) -> Bool {
  case m == 1 || n == 1 {
    True -> True
    False -> case m <= n {
      False -> are_coprime(n, m, divisor)
      True -> case n % m == 0 {
        True -> False
        False -> case divisor <= m / 2 {
          False -> True
          True -> case m % divisor == 0, n % divisor == 0 {
            True, True -> False
            _, _ -> are_coprime(m, n, divisor + 1)
          }
        }
      }
    }
  }
}

fn sqr(num: Int) -> Int {
  let assert Ok(root) = int.square_root(num)
  float.round(root)
}

fn possible_m_n(m: Int, n: Int, m_max: Int, target: Int, acc: List(#(Int, Int))) -> List(#(Int, Int)) {
  case m <= m_max {
    False -> acc
    True -> case n < m {
      False -> possible_m_n(m + 1, 1, m_max, target, acc)
      True -> case m * {m + n} <= target {
        False -> possible_m_n(m + 1, 1, m_max, target, acc)
        True -> case target % {m * {m + n}} == 0 {
          True -> possible_m_n(m, n + 1, m_max, target, [#(m, n), ..acc])
          False -> possible_m_n(m, n + 1, m_max, target, acc)
        }
      }
    }
  }
}

fn add_k(mn: List(#(Int, Int)), product: Int, acc: List(#(Int, Int, Int))) -> List(#(Int, Int, Int)) {
  case mn {
    [] -> acc
    [first, ..rest] -> add_k(rest, product, [#(product / {first.0 * {first.0 + first.1}}, first.0, first.1), ..acc])
  }
}

fn opposite_parity(m: Int, n: Int) -> Bool {
  m % 2 != n % 2
}

fn triplet_compare(a: Triplet, b: Triplet) -> Order {
  let Triplet(x, _, _) = a
  let Triplet(y, _, _) = b
  case x < y {
    True -> Lt
    False -> Gt
  }
}