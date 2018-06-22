/*:
 Like many OOP languages, Swift's protocol and class mechanisms allow for subtype polymorphism (or "inclusion polymorphism"). This is the polymorphism many of us are first introduced to.
 */

protocol Inspectable {
    func info() -> String
}

class Shape: Inspectable {
    func info() -> String {
        return "shape"
    }
}

class Square: Shape {
    override func info() -> String {
        return "square"
    }
}

class Circle: Shape {
    override func info() -> String {
        return "circle"
    }
}

var shape: Shape

/*:
 The `shape` variable can refer to many different types of classes, thus the output of `shape.info()` changes.
 */

shape = Shape()
shape.info()
shape = Square()
shape.info()
shape = Circle()
shape.info()
