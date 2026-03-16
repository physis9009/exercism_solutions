pub type Planet {
  Mercury
  Venus
  Earth
  Mars
  Jupiter
  Saturn
  Uranus
  Neptune
}

pub fn age(planet: Planet, seconds: Float) -> Float {
  let earth_age = seconds /. 31_557_600.0
  case planet {
    Mercury -> earth_age /. 0.2408467
    Venus -> earth_age /. 0.61519726
    Earth -> earth_age
    Mars -> earth_age /. 1.8808158
    Jupiter -> earth_age /. 11.862615
    Saturn -> earth_age /. 29.447498
    Uranus -> earth_age /. 84.016846
    Neptune -> earth_age /. 164.79132
  }
}
