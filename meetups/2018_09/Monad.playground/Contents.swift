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


// ------------------------------------
//          Monads
// ------------------------------------

// Monads??? 🤔


// ------------------------------------
//   Functor refresher: (Optional) Map
// ------------------------------------


Int?.some(2)
    .map(square)
    .map(incr)

Int?.none
    .map(square >>> incr)

// Transforms:
// A -> B (square)
//   +
// B -> C (incr)
//   =
// A -> C


func freeMap<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
    return {
        switch $0 {
        case let .some(a):
            return .some(f(a))
        case .none:
            return .none
        }
    }
}

let free = Int?.some(3)
    |> freeMap(square)
    >>> freeMap(incr)


// Transforms:
// A -> B (square)
//   +
// B -> C (incr)
//   =
// A -> C

// Cool

// How to Transform?
// A -> M<B>
//   +
// B -> M<C>
//   =
// A -> M<C>


// ------------------------------------
//    Detour: Flatmap vs Compact Map
// ------------------------------------

// flatMap : ((A) -> [B]) -> ([A]) -> [B]
// flatMap : ((A) ->  B?) -> ( A?) ->  B?
// flatMap : ((A) ->  B?) -> ([A]) -> [B]


// ------------------------------------
//   Optional Map vs Optional Flatmap
// ------------------------------------

//     map : ((A) -> B ) -> (A?) -> B?
// flatMap : ((A) -> B?) -> (A?) -> B?

//     map : ((A) ->          B ) -> (Optional<A>) -> Optional<B>
// flatMap : ((A) -> Optional<B>) -> (Optional<A>) -> Optional<B>

//     map : ((A) ->   B ) -> (M<A>) -> M<B>
// flatMap : ((A) -> M<B>) -> (M<A>) -> M<B>


// ------------------------------------
//   Transform functions for Flatmap
// ------------------------------------

func freeFlatMap<A, B>(_ f: @escaping (A) -> B?) -> (A?) -> B? {
    return {
        switch $0 {
        case let .some(a):
            return f(a)
        case .none:
            return .none
        }
    }
}

func freeFlatMap2<A, B>(_ f: @escaping (A) -> B?) -> (A?) -> B? {
    return {
        switch $0 {
        case let .some(a):
            return f(a)
        case .none:
            return nil
        }
    }
}

func freeFlatMap3<A, B>(_ f: @escaping (A) -> B?) -> (A?) -> B? {
    return { a in
        if let someA = a {
            let b = f(someA)
            return b
        } else {
            return nil
        }
    }
}

func freeFlatMap4<A, B>(_ f: @escaping (A) -> B?) -> (A?) -> B? {
    return { a in
        guard let someA = a else { return nil }
        return f(someA)
    }
}

// https://github.com/apple/swift/blob/master/stdlib/public/core/Optional.swift


func squareMaybe(_ x: Int) -> Int? { return x % 2 == 0 ? .none: .some(x * x) }
func incrMaybe(_ x: Int) -> Int? { return x % 2 == 0 ? .none: .some(x + 1) }

let three = Int?.some(3)
    |> freeFlatMap(squareMaybe)
    >>> freeFlatMap(incrMaybe)

let two = Int?.some(2)
    |> freeFlatMap(squareMaybe)

