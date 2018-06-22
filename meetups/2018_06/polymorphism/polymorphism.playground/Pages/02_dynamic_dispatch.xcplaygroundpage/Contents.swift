
/*:
 Methods defined in a protocol are *dynamically dispatched*. This means that at runtime when something that is `Inspectable` has one of these methods called, the runtime needs to check the type of the instance and call the appropriate implementation. This makes sense because something that is `Inspectable` could really be anything! It could be a `Shape` or `Square`, etc.
 
 This is the opposite of *static dispatch* where the compiler "knows" exactly what implementation needs to be called and optimizes by calling the method implementation directly.
 
 When a variable's "type" is a protocol, the method calls are dynamically dispatched.
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

class Square: Shape {
    override func info() -> String {
        return "square"
    }
    
    override func detailedInfo() -> String {
        return "detailed square info"
    }
}

/*:
 The following method calls are dynamically dispatched.
 */
let square: Inspectable = Square()
square.info()
square.detailedInfo()

let someShape: Inspectable = Shape()
someShape.info()
someShape.detailedInfo()

/*:
 In fact, in this case, even if we use type inference or explicitly set the type to `Square`, dynamic dispatch will still be used. We will see why in the next section.
 
 Still dynamically dispatched:
 */

let square2 = Square()
square2.info()
square2.detailedInfo()
