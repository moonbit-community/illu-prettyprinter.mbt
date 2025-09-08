///|
pub fn Line::from_string(indentation? : Int = 0, str : &IsString) -> Line {
  Line::new(indentation~, @immut_deque.singleton(str))
}

///|
pub fn Line::from_iter(indentation? : Int = 0, iter : Iter[&IsString]) -> Line {
  Line::new(indentation~, @immut_deque.from_iter(iter))
}

///|
pub fn Line::new(indentation? : Int = 0, deque : Deque[&IsString]) -> Line {
  { inden: indentation, texts: deque }
}

///|
pub fn Line::empty() -> Line {
  Line::new(indentation=0, @immut_deque.empty())
}

///|
pub fn Line::cons(self : Line, text : &IsString) -> Line {
  Line::new(indentation=self.inden, self.texts.cons(text))
}

///|
pub fn Line::snoc(self : Line, text : &IsString) -> Line {
  Line::new(indentation=self.inden, self.texts.snoc(text))
}

///|
pub fn Line::append(self : Line, other : Line) -> Line {
  Line::new(indentation=self.inden, self.texts.append(other.texts))
}

///|
pub fn Line::indent(self : Line, n : Int) -> Line {
  Line::new(indentation=self.inden + n, self.texts)
}

///|
pub fn Line::width(self : Line) -> Int {
  self.texts.foldl(self.inden, fn(acc : Int, text : &IsString) -> Int {
    acc + text.length()
  })
}

///|
pub fn Line::iter(self : Line) -> Iter[&IsString] {
  Iter::singleton(" ".repeat(self.inden)) + self.texts.iter()
  // TODO 
}
