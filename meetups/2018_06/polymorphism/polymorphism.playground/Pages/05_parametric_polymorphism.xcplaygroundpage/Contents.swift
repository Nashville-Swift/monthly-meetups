
// Parametric Polymorphism (or in OOP: "generics")
// Parametric: influenced by a value or parameter.

// Typealiases can now be parameterized
typealias List<T> = Array<T>

struct Bag<T> {
    var values: [T] = []
    mutating func add(_ object: T) {
        values.append(object)
    }
}

var bag = Bag<String>()
bag.add("5")
bag.add("abc")

bag.values[1].uppercased()

var bagOfNumbers = Bag<Int>()
bagOfNumbers.add(1)
bagOfNumbers.add(2)
bagOfNumbers.add(3)

bagOfNumbers.values.reduce(0, +)
