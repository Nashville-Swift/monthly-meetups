/*:
 Why would we want static dispatch? Generally, it is more performant. Generally, it also requires giving a compiler some hints about how to optimize the code. We'll look a few examples.
 */
protocol Inspectable {
    func info() -> String
    func detailedInfo() -> String
}

class Shape: Inspectable {
    func info() -> String {
        return "shape"
    }
    
    func detailedInfo() -> String {
        return "detailed shape info"
    }
}

/*:
 The first hint we can give the compiler is by telling it that a class cannot be subclassed. We do this using `final`.
 */

final class Square: Shape {
    override func info() -> String {
        return "square"
    }
    
    override func detailedInfo() -> String {
        return "detailed square info"
    }
}

/*:
 Since the compiler knows that any type `Square` must be a `Square` it has all the information it needs to perform static dispatch:
 */

let square = Square()
square.info()
square.detailedInfo()

/*:
 This will still produce dynamic dispatch because the type is `Shape`:
 */

let someShape: Shape = Square()
someShape.info()
someShape.detailedInfo()

/*:
 Marking a method has `private` will also enable static dispatch.
 
 Lastly, but importantly, functions defined in protocol extensions will be statically dispatched. This can lead to confusion if you aren't careful!
 */

protocol Inspectable2 {
    func info() -> String
}

extension Inspectable2 {
    func detailedInfo() -> String {
        return "undefined"
    }
}

final class Shape2: Inspectable2 {
    func info() -> String {
        return "shape2"
    }
    
    func detailedInfo() -> String {
        return "detailed shape2 info"
    }
}

let shape2: Inspectable2 = Shape2()
shape2.info()

/*:
 Protocols dispatch dynamically right? Not in this case. We expec to see `detailed shape2 info` but we actually see `undefined`.
 */

shape2.detailedInfo()
