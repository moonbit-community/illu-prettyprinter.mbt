///|
using @immut_deque {type T as Deque}

///|
struct Line {
  inden : Int
  texts : Deque[&IsString]
}

// derive(Show)

///|
struct Doc(Deque[Line])
