// ------------------------------------
//          Operators
// ------------------------------------

precedencegroup ForwardApplication {
    associativity: left
    higherThan: ComparisonPrecedence
}
infix operator |>: ForwardApplication

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}
infix operator >>>: ForwardComposition

public func |> <A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

// ------------------------------------
//          Functions
// ------------------------------------

func incr(_ x: Int) -> Int { return x + 1 }
func square(_ x: Int) -> Int { return x * x }
func numberToString(_ x: Int) -> String { return String(x) }

// Map - Unwrapping, mapping over, rewrapping


// MARK: Array

[1, 2, 3]
    .map(square)
    .map(incr)

[1, 2, 3]
    .map(square >>> incr)


// MARK: Optional

Int?.some(2)
    .map(square)
    .map(incr)

Int?.none
    .map(square >>> incr)


// MARK: String

"Matthew".map{ $0 }
print("Matthew".map{ $0 })


// ***Functor is any type/context/container that defines how map is applied to it***


// ------------------------------------
//          Map of Id = Id
// ------------------------------------


// Identity function: takes a value and returns it back

func id<A>(_ a: A) -> A {
    return a
}


// MARK: Array

[1, 2, 3]
    .map (id)

[1, 2, 3].map(id) == id([1, 2, 3]) // map(id) == id


// MARK: Optional

Int?.some(2)
    .map (id)

Int?.some(2).map(id) == id(Int?.some(2)) // map(id) == id


// MARK: String

"Matthew".map(id) // ["M", "a", "t", "t", "h", "e", "w"]
id("Matthew") // "Matthew"
// "Matthew".map(id) == id("Matthew") // map(id) == id // !TRUE


// ------------------------------------
// Map Compositions == Composition Maps
// ------------------------------------


// MARK: Array

// Map of compositions
[1, 2, 3]
    .map(incr >>> square)

// Composition of maps
[1, 2, 3]
    .map(incr)
    .map(square)

[1, 2, 3].map(square).map(incr) == [1, 2, 3].map(square >>> incr) // map(f * g) == map(f) * map(g)
[1, 2, 3].map(square).map(numberToString) == [1, 2, 3].map(square >>> numberToString)


// MARK: Optional

Int?.some(2)
    .map(incr >>> square)

Int?.some(2)
    .map(incr)
    .map(square)


// MARK: String

func now(_ x: String) -> String { return x + "NOW" }
func exclaim(_ x: String) -> String { return x + "!" }

// Map of compositions
//"Matthew".map(now >>> exclaim) // Can not convert

// Composition of maps
//"Matthew".map(now).map(exclaim) // Can not convert
