use std::io::{Read, Result, Write};

pub struct ReadStats<R> {
    wrapped: R,
    bytes: usize,
    reads: usize,
}

impl<R: Read> ReadStats<R> {
    pub fn new(wrapped: R) -> ReadStats<R> {
        ReadStats {
            wrapped,
            bytes: 0,
            reads: 0,
        }
    }

    pub fn get_ref(&self) -> &R {
        &self.wrapped
    }

    pub fn bytes_through(&self) -> usize {
        self.bytes
    }

    pub fn reads(&self) -> usize {
        self.reads
    }
}

impl<R: Read> Read for ReadStats<R> {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        let result = self.wrapped.read(buf);
        match result {
            Ok(n) => {
                self.bytes += n;
                self.reads += 1;
                Ok(n)
            }
            _ => result,
        }
    }
}

pub struct WriteStats<W> {
    wrapped: W,
    bytes: usize,
    writes: usize,
}

impl<W: Write> WriteStats<W> {
    pub fn new(wrapped: W) -> WriteStats<W> {
        WriteStats {
            wrapped,
            bytes: 0,
            writes: 0,
        }
    }

    pub fn get_ref(&self) -> &W {
        &self.wrapped
    }

    pub fn bytes_through(&self) -> usize {
        self.bytes
    }

    pub fn writes(&self) -> usize {
        self.writes
    }
}

impl<W: Write> Write for WriteStats<W> {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        let result = self.wrapped.write(buf);
        match result {
            Ok(n) => {
                self.bytes += n;
                self.writes += 1;
                Ok(n)
            }
            _ => result,
        }
    }

    fn flush(&mut self) -> Result<()> {
        self.wrapped.flush()
    }
}
