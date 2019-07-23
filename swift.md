# The Swift language

Please consult the 'A Swift Tour' chapter, from the book 'The Swift Programming Language' available for free on the AppStore, in eBook version,
or on the website 'swift.org'.

## Main characteristics
- compiled
- object oriented
- procedural
- imperatif

## Syntaxic faciliation
The semi-colon is optional if a line contains a single instruction.

Parenthesis around conditions are also optional.

A variable type might be deduced from the context
and indicating this type is not always required.
Example :
```swift
// 'ten' is a constant whose type is Int
let ten = 10
```

## Flow control instructions
- while and do-while loops, for
- switch and if statements
- guard clause

Every switch statement must be exhaustive (it is ought to contain a `default` clause to cover any value).
A clause might contain the instruction `fallthrough` in order for the next one to be executed.
The behaviour differs from the C language, where the `break` instruction is prone to be forgotten
and lead to unwanted behaviour.

The `guard` clause must contain an instructino that make the flow leave its current scope,
such as `return [value]` for a function, or `break` for a loop.
It allows not to write `if !(condition)`, provides better code readibility and clarifies the intent.

## Classes and structures
Classes are passed by reference and stuctures by value (often copied when used as functions argument).
Variable declaration:
- var \<variable name\> = \<initialization value\>.
- var \<variable name\>: \<Type\>
- var \<variable name\>: \<Type\> = \<initialization value\>.
Constant declaration:
- let \<variable name\> = \<initialization value\>.
- let \<variable name\>: \<Type\>
- let \<variable name\>: \<Type\> = \<initialization value\>.

## Functions
Declaration : func \<function name\>([\<arguments\> ...]) [-> \<Return type\>]

## Optionals
Optionals are declared by adding an interrogation point after the variable type.
It might then take an value of its type or the special one `nil`.
It might be compared to a pointer in C or C++ that might have the `NULL` value (the pointer refers the to `0` address).
```
// The variable myInteger will take the value of optionalInteger
// if it is defined or will take the value of the non optional value 
// nonOptionalInteger otherwise.
let myInteger = optionalInteger ?? nonOptionalInteger
```
