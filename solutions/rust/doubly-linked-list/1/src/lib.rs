use std::marker::PhantomData;
use std::ptr;

mod pre_implemented;

struct Node<T> {
    value: T,
    prev: Option<*mut Node<T>>,
    next: Option<*mut Node<T>>,
}

pub struct LinkedList<T> {
    head: Option<*mut Node<T>>,
    tail: Option<*mut Node<T>>,
    len: usize,
}

pub struct Cursor<'a, T> {
    cur: Option<*mut Node<T>>,
    list: &'a mut LinkedList<T>,
}

pub struct Iter<'a, T> {
    cur: Option<*mut Node<T>>,
    list: PhantomData<&'a LinkedList<T>>,
}

impl<T> LinkedList<T> {
    pub fn new() -> Self {
        Self { head: None, tail: None, len: 0 }
    }

    pub fn is_empty(&self) -> bool {
        self.len == 0
    }

    pub fn len(&self) -> usize {
        self.len
    }

    /// Return a cursor positioned on the front element
    pub fn cursor_front(&mut self) -> Cursor<'_, T> {
        Cursor {
            cur: self.head,
            list: self,
        }
    }

    /// Return a cursor positioned on the back element
    pub fn cursor_back(&mut self) -> Cursor<'_, T> {
        Cursor {
            cur: self.tail,
            list: self,
        }
    }

    /// Return an iterator that moves from front to back
    pub fn iter(&self) -> Iter<'_, T> {
        Iter {
            cur: self.head,
            list: PhantomData,
        }
    }
}

impl<T> Drop for LinkedList<T> {
    fn drop(&mut self) {
        let mut cur = self.head;
        while let Some(p) = cur {
            // SAFETY: p 是本链表有效节点；先取 next 再释放 p，避免释放后读 (*p).next。
            cur = unsafe { (*p).next };
            // SAFETY: p 由 Box::into_raw 分配，且本链表独占，只释放一次。
            unsafe { drop(Box::from_raw(p)); }
        }
    }
}

impl<T> Cursor<'_, T> {
    /// Take a mutable reference to the current element
    pub fn peek_mut(&mut self) -> Option<&mut T> {
        let cur = self.cur?;
        // SAFETY: cursor invariant 保证 cur 有效且属于本链表；
        // &mut self 独占 cursor，无别名 &mut。&mut (*cur).value 只取字段引用，不移动。
        Some(unsafe { &mut (*cur).value })
    }

    /// Move one position forward (towards the back) and
    /// return a reference to the new position
    pub fn next(&mut self) -> Option<&mut T> {
        let cur = self.cur?;
        // SAFETY: cur 有效（cursor invariant）。
        let next = unsafe { (*cur).next };
        match next {
            Some(p) => {
                self.cur = Some(p);
                // SAFETY: p 是本链表有效节点；&mut self 独占。
                Some(unsafe { &mut (*p).value })
            }
            // 越界：不改 self.cur，仍停在当前（tail）元素上。
            None => None,
        }
    }

    /// Move one position backward (towards the front) and
    /// return a reference to the new position
    pub fn prev(&mut self) -> Option<&mut T> {
        let cur = self.cur?;
        // SAFETY: cur 有效（cursor invariant）。
        let prev = unsafe { (*cur).prev };
        match prev {
            Some(p) => {
                self.cur = Some(p);
                // SAFETY: p 是本链表有效节点；&mut self 独占。
                Some(unsafe { &mut (*p).value })
            }
            // 越界：不改 self.cur，仍停在当前（head）元素上。
            None => None,
        }
    }

    /// Remove and return the element at the current position and move the cursor
    /// to the neighboring element that's closest to the back. This can be
    /// either the next or previous position.
    pub fn take(&mut self) -> Option<T> {
        let p_token = self.cur?;
        // SAFETY: p_token 是本链表有效节点（cursor invariant）。
        let prev = unsafe { (*p_token).prev };
        let next = unsafe { (*p_token).next };

        match (prev, next) {
            (Some(p_prev), Some(p_next)) => unsafe {
                (*p_prev).next = next;
                (*p_next).prev = prev;
            },
            (Some(p_prev), None) => unsafe {
                (*p_prev).next = None;
            },
            (None, Some(p_next)) => unsafe {
                (*p_next).prev = None;
            },
            (None, None) => {}
        }

        // 更新链表头尾与长度。
        if prev.is_none() {
            self.list.head = next;
        }
        if next.is_none() {
            self.list.tail = prev;
        }
        self.list.len -= 1;

        // cursor 移到"靠后的邻居，否则前一个"。
        self.cur = match next {
            Some(p_next) => Some(p_next),
            None => prev,
        };

        // SAFETY: p_token 由 Box::into_raw 分配，且本链表独占，只释放一次；
        // value 用 ptr::read 移出后节点不再被读。
        let value = unsafe { ptr::read(&(*p_token).value) };
        // SAFETY: 同上，释放节点本身。
        unsafe { drop(Box::from_raw(p_token)); }
        Some(value)
    }

    pub fn insert_after(&mut self, element: T) {
        // SAFETY: 新节点由 Box::into_raw 分配，所有权交给链表。
        let new = Box::into_raw(Box::new(Node {
            value: element,
            prev: None,
            next: None,
        }));
        match self.cur {
            Some(p) => {
                // SAFETY: p 是本链表有效节点（cursor invariant）。
                let next = unsafe { (*p).next };
                // SAFETY: new 是新分配节点；p 有效；next 若存在则是本链表有效节点。
                unsafe {
                    (*new).prev = Some(p);
                    (*new).next = next;
                    (*p).next = Some(new);
                    if let Some(p_next) = next {
                        (*p_next).prev = Some(new);
                    }
                }
                // 若 p 是 tail，new 成为新 tail。
                if next.is_none() {
                    self.list.tail = Some(new);
                }
            }
            None => {
                // 空链表：new 是唯一节点，同时是 head 和 tail。
                self.list.head = Some(new);
                self.list.tail = Some(new);
                self.cur = Some(new);
            }
        }
        self.list.len += 1;
    }

    pub fn insert_before(&mut self, element: T) {
        // SAFETY: 新节点由 Box::into_raw 分配，所有权交给链表。
        let new = Box::into_raw(Box::new(Node {
            value: element,
            prev: None,
            next: None,
        }));
        match self.cur {
            Some(p) => {
                // SAFETY: p 是本链表有效节点（cursor invariant）。
                let prev = unsafe { (*p).prev };
                // SAFETY: new 是新分配节点；p 有效；prev 若存在则是本链表有效节点。
                unsafe {
                    (*new).next = Some(p);
                    (*new).prev = prev;
                    (*p).prev = Some(new);
                    if let Some(p_prev) = prev {
                        (*p_prev).next = Some(new);
                    }
                }
                // 若 p 是 head，new 成为新 head。
                if prev.is_none() {
                    self.list.head = Some(new);
                }
            }
            None => {
                // 空链表：new 是唯一节点，同时是 head 和 tail。
                self.list.head = Some(new);
                self.list.tail = Some(new);
                self.cur = Some(new);
            }
        }
        self.list.len += 1;
    }
}

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;

    fn next(&mut self) -> Option<&'a T> {
        let p = self.cur?;
        // SAFETY: p 来自本链表；Iter 借 &'a list，期间 list 不可变，
        // 节点不会释放/修改；返回 &'a T 活到 'a 合法。
        self.cur = unsafe { (*p).next };
        Some(unsafe { &(*p).value })
    }
}