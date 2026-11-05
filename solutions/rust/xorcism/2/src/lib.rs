pub trait Byte {
    fn byte(self) -> u8;
}
impl Byte for u8 {
    fn byte(self) -> u8 { self }
}
impl Byte for &u8 {
    fn byte(self) -> u8 { *self }
}

#[derive(Clone)]
pub struct Xorcism<'a> {
    key: &'a [u8],
    key_offset: usize,  
}

impl<'a> Xorcism<'a> {
    pub fn new<Key>(key: &'a Key) -> Xorcism<'a>
    where
        Key: AsRef<[u8]> + ?Sized,
    {
        Self { key: key.as_ref(), key_offset: 0 }
    }

    fn xor_byte(&mut self, b: u8) -> u8 {
        let out = b ^ self.key[self.key_offset];
        self.key_offset = (self.key_offset + 1) % self.key.len();
        out
    }

    pub fn munge_in_place(&mut self, data: &mut [u8]) {
        for d in data.iter_mut() {
            *d = self.xor_byte(*d);   
        }
    }

    pub fn munge<'b, Data>(&'b mut self, data: Data) -> impl Iterator<Item = u8> + 'b
    where
        Data: IntoIterator,
        Data::Item: Byte,
        <Data as IntoIterator>::IntoIter: 'b,
    {
        struct MungeIter<'k, I> {
            key: &'k [u8],
            offset: &'k mut usize,
            iter: I,
        }
        impl<'k, I> Iterator for MungeIter<'k, I>
        where
            I: Iterator,
            I::Item: Byte,
        {
            type Item = u8;
            fn next(&mut self) -> Option<u8> {
                let b = self.iter.next()?.byte();
                let out = b ^ self.key[*self.offset];
                *self.offset = (*self.offset + 1) % self.key.len();
                Some(out)
            }
        }
        MungeIter {
            key: self.key,
            offset: &mut self.key_offset,
            iter: data.into_iter(),
        }
    }
}
