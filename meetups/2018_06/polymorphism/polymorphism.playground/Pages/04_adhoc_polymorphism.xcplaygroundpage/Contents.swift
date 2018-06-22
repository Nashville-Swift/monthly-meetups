
// ad hoc polymorphism
// operator overloading, function overloading
// "ad hoc" because it can be implemented without changing the language

func combine(a: Int, b: Int) -> Int {
    return a + b
}

combine(a: 1, b: 2)

func combine(a: String, b: String) -> String {
    return a + b
}

combine(a: "a", b: "b")

// examples

Optional(1).map { $0 + 1 }
[1].map { $0 + 1 }
