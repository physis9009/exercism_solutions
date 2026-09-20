#[derive(Debug)]
pub struct ChessPosition {
    rank: i32,
    file: i32,
}

#[derive(Debug)]
pub struct Queen(ChessPosition);

impl ChessPosition {
    pub fn new(rank: i32, file: i32) -> Option<Self> {
        if rank >=0 && rank <= 7 && file >= 0 && file <= 7 {
            Some(ChessPosition {rank, file})
        } else { None }
    }
}

impl Queen {
    pub fn new(position: ChessPosition) -> Self {
        Queen(position)
    }

    pub fn can_attack(&self, other: &Queen) -> bool {
        (self.0.rank - other.0.rank).abs() == (self.0.file - other.0.file).abs()
            || self.0.rank == other.0.rank
            || self.0.file == other.0.file
    }
}
