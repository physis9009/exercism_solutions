pub struct CircularBuffer<T> {
    buffer: Vec<Option<T>>,
    capacity: usize,
    head: usize,
    current: usize,
}

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    EmptyBuffer,
    FullBuffer,
}

impl<T: Clone> CircularBuffer<T> {
    pub fn new(capacity: usize) -> Self {
        let mut buffer = Vec::new();
        buffer.resize_with(capacity * 10, || None);
        
        Self {
            buffer,
            capacity,
            head: 0,
            current: 0,
        }
    }

    pub fn write(&mut self, element: T) -> Result<(), Error> {
        if self.current - self.head >= self.capacity { return Err(Error::FullBuffer); }

        self.buffer[self.current] = Some(element);
        self.current += 1;
        Ok(())
    }

    pub fn read(&mut self) -> Result<T, Error> {
        if self.head == self.current { return Err(Error::EmptyBuffer); }

        let value = self.buffer[self.head].clone().unwrap();
        self.head += 1;
        Ok(value)
    }

    pub fn clear(&mut self) {
        let mut buffer = Vec::new();
        buffer.resize_with(self.capacity * 10, || None);
        
        self.buffer = buffer;
        self.head = 0;
        self.current = 0;
    }

    pub fn overwrite(&mut self, element: T) {
        match self.write(element.clone()) {
            Ok(()) => return,
            Err(_) => {
                self.buffer[self.current] = Some(element);
                self.head += 1;
                self.current += 1;    
            }
        }
    }
}
