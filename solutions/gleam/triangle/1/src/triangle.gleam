import gleam/list

pub fn equilateral(a: Float, b: Float, c: Float) -> Bool {
  case is_triangle(a, b, c) {
    False -> False
    True -> case a -. b, b -. c {
        0.0, 0.0 -> True
        _, _ -> False
    }
  }
}

pub fn isosceles(a: Float, b: Float, c: Float) -> Bool {
  case is_triangle(a, b, c) {
    False -> False
    True -> list.contains([a -. b, b -. c, c -. a], 0.0)
  }
}

pub fn scalene(a: Float, b: Float, c: Float) -> Bool {
  case is_triangle(a, b, c) {
    False -> False
    True -> !equilateral(a, b, c) && !isosceles(a, b, c)
  }
}

fn is_triangle(a: Float, b: Float, c: Float) -> Bool {
  case a +. b, b +. c, c +. a {
    s1, s2, s3 if s1 <=. c || s2 <=. a || s3 <=. b -> False
    _, _, _ -> True
  }
}