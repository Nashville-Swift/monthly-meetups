
/*:
 What is a function?
 */

typealias FUNCTION = (Any) -> Any












/*:
 How could we represent integers?
 
 Let's consider the natural numbers (whole numbers from zero onward). How can we define a formula for calculating any natural number using a minimal number of components or "types of things that we compose together".
 
 Let's try just using three symbols: "0", "1", and "+".
 
 0 = 0
 1 = 1 + 0
 2 = 1 + 1 + 0
 3 = 1 + 1 + 1 + 0
 
 Imagine we have a function called `succ` that given an input number, returns the next number.
 
 0 = zero
 1 = succ(zero)
 2 = succ(succ(zero))
 3 = succ(succ(succ(zero)))
 ...
 
 Given zero, any other natural number is just N successors of zero!
 
 What do we need to write this in Swift? We need the successor function and we need zero. But wait! We can't write a successor function because we decided not to use addition and we can't use zero because we decided not to use numbers! That's OK. The beauty of higher-order functions is that we can just pretend we have things when we don't.
 
 Let's make some numbers.
 */







//   FUNCTION =         Any          ->   Any
typealias INT = (@escaping FUNCTION) -> FUNCTION

let ZERO: INT = { _ in
    return { (x: Any) in
        x
    }
}

let ONE: INT = { f in
    return { (x: Any) in
        f(x)
    }
}

let TWO: INT = { f in
    return { (x: Any) in
        f(f(x))
    }
}

let THREE: INT = { f in
    return { (x: Any) in
        f(f(f(x)))
    }
}










/*:
 Ok, does this actually work? It does:
 */

var x = THREE { x in
    return x as! Int + 1
}
x(0)

/*:
 That isn't nice to look at so let's abstract it and put it aside.
 */

func toInt(_ numeral: INT) -> Int {
    return numeral { $0 as! Int + 1 }(0) as! Int
}

toInt(ZERO)
toInt(ONE)
toInt(TWO)
toInt(THREE)














/*:
 Let's make addition with adding:
 */















let ADD: (@escaping INT, @escaping  INT) -> INT = { n1, n2 in
    return { f in
        return { x in
            return n1(f)(n2(f)(x))
        }
    }
}











let FIVE = ADD(TWO, THREE)
toInt(FIVE)















/*:
 What about booleans? What does a boolean do?
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 Booleans allow us to make choices. It is either "this" or "that". If true, we do A. If false we do B. If we think of an `if else` statement as a FUNCTION, whenever the input is true, we always do the `if` part and whenever the input is false, we always do the `else` part. We can each "part" of the `if else` condition as a FUNCTION:
 
 if (someBoolean) {
 trueFUNCTION()
 } else {
 falseFUNCTION()
 }
 
 We know that a boolean is eventually going to be a FUNCTION since everything is FUNCTIONs. When we think about it like this, an `if else` statement is really just a FUNCTION that takes three arguments: a boolean, a true FUNCTION, and a false FUNCTION. So `if else` just takes three "FUNCTIONS".
 
 What about just plain `if` statements with no `else`?
 
 These are really just `if else` statements where the else part does nothing.
 
 What about `else if` statements or switches?
 
 Every `else if` statement can be rewritten as a group of nested `if else` statements! The same logic applies to switches and pattern matching. Essentially, they are just sugar for the binary `if else`.
 
 Therefore, we will only concern ourselves with constructing the `if else` FUNCTION.
 */

typealias BOOLEAN = (@escaping FUNCTION, @escaping FUNCTION) -> FUNCTION

let TRUE: BOOLEAN = { f1, _ in
    return { x in
        f1(x)
    }
}

let FALSE: BOOLEAN = { _, f2 in
    return { x in
        f2(x)
    }
}

let IF: (@escaping BOOLEAN, @escaping FUNCTION, @escaping FUNCTION) -> FUNCTION = { bool, f1, f2 in
    return bool(f1, f2)
}

IF(
    TRUE,
    { x in print("true"); return x },
    { x in print("false"); return x }
    )(0)

IF(
    TRUE,
    ONE { $0 as! Int + 1 },
    TWO { $0 as! Int + 1 }
    )(0)

let INCREMENT: FUNCTION = { print("INCREMENT"); return $0 }

let lambda_if =
    IF(
        FALSE,
        ADD(THREE, TWO)(INCREMENT),
        TWO(INCREMENT)
)

lambda_if(0)
