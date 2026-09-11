#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    NotEnoughPinsLeft,
    GameComplete,
}
    
pub struct BowlingGame {
    record: Vec<u16>,
    frame: u8,
    throw: u8,
    complete: bool,
    fill_balls: u8,
}

impl BowlingGame {
    pub fn new() -> Self {
        BowlingGame {
            record: Vec::new(),
            frame: 1,
            throw: 1,
            complete: false,
            fill_balls: 0,
        }
    }

    pub fn roll(&mut self, pins: u16) -> Result<(), Error> {
        if pins > 10 { return Err(Error::NotEnoughPinsLeft); }
        if self.complete { return Err(Error::GameComplete); }
        
        if self.frame < 10 {
            if self.throw == 1 {
                if pins == 10 {
                    self.record.push(pins);
                    self.frame += 1;
                    Ok(())
                } else {
                    self.record.push(pins);
                    self.throw = 2;
                    Ok(())
                }
            } else {
                if let Some(&prev) = self.record.last() {
                    if prev + pins > 10 { return Err(Error::NotEnoughPinsLeft); }

                    self.record.push(pins);
                    self.frame += 1;
                    self.throw = 1;
                    Ok(())
                } else { unreachable!(); }
            }    
        } else {
            match self.throw {
                1 => {
                    self.record.push(pins);
                    if pins == 10 {
                        self.throw = 3;
                        self.fill_balls = 2;
                        Ok(())
                    } else {
                        self.throw = 2;
                        Ok(())
                    }
                }
                2 => {
                    if let Some(&prev) = self.record.last() {
                        if prev + pins > 10 {
                            return Err(Error::NotEnoughPinsLeft);
                        }
                        self.record.push(pins);
                        if prev + pins == 10 {
                            self.throw = 3; 
                            self.fill_balls = 1;
                            Ok(())
                        } else {
                            self.complete = true;
                            Ok(())
                        }
                    } else { unreachable!(); }
                }
                3 => {
                    self.record.push(pins);
                    if self.fill_balls == 2 {
                        self.throw = 4;
                        Ok(())
                    } else {
                        self.complete = true;
                        Ok(())
                    }
                }
                4 => {
                    if let Some(&prev) = self.record.last() {
                        if prev == 10 {
                            self.record.push(pins);
                            self.complete = true;
                            Ok(())
                        } else {
                            if prev + pins > 10 { return Err(Error::NotEnoughPinsLeft); }

                            self.record.push(pins);
                            self.complete = true;
                            Ok(())
                        }
                    } else { unreachable!(); }
                }
                _ => unreachable!(),
            }
        }
    }

    pub fn score(&self) -> Option<u16> {
        if !self.complete { return None; }

        let mut counter = 0;
        let mut i = 0;
        let mut result = 0;
        while counter < 9 {
            if self.record[i] == 10 {
                result += 10 + self.record[i + 1] + self.record[i + 2];
                counter += 1;
                i += 1;
            } else if self.record[i] + self.record[i + 1] == 10 {
                result += 10 + self.record[i + 2];
                counter += 1;
                i += 2;
            } else {
                result += self.record[i] + self.record[i + 1];
                counter += 1;
                i += 2;
            }
        }

        let len = self.record.len();
        while i < len {
            result += self.record[i];
            i += 1;
        }

        Some(result)
    }
}
