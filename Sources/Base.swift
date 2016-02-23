//
//  Base.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that consumes no input and returns `value`.

    - Parameter value: The value to return on parse.
*/
@warn_unused_result public func pure<Token, Result>(value: Result) -> Parser<Token, Result> {
    return Parser { _ in
        return value
    }
}

/**
    Constructs a `Parser` that consumes no input, succeeds, and returns nothing.
*/
@warn_unused_result public func none<Token>() -> Parser<Token, ()> {
    return pure(())
}

/**
    Constructs a `Parser` that consumes a single token and returns it.
*/
@warn_unused_result public func any<Token>() -> Parser<Token, Token> {
    return Parser { input in
        return try input.read()
    }
}

/**
    Constructs a `Parser` that succeeds if the input is empty. This parser
    consumes no input and returns nothing.
*/
@warn_unused_result public func end<Token>() -> Parser<Token, ()> {
    return Parser { input in
        do {
            try input.read()
            throw ParseError.Failure("end")
        } catch let error as ParseError {
            guard case .EndOfStream = error else { throw error }
        }
    }
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it satisfies `condition`; otherwise, it throws a `ParseError`.
 
    - Parameter condition: The condition that the token must satisfy.
*/
@warn_unused_result public func satisfy<Token>(condition: Token -> Bool) -> Parser<Token, Token> {
    return any().require(condition)
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is equal to the argument `token`.
 
    - Parameter token: The token that the input is tested against.
 */
@warn_unused_result public func token<Token: Equatable>(token: Token) -> Parser<Token, Token> {
    return satisfy{ $0 == token }.expect(String(token))
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is within the interval `interval`.
 
    - Parameter interval: The interval that the input is tested against.
 */
@warn_unused_result public func within<I: IntervalType>(interval: I) -> Parser<I.Bound, I.Bound> {
    return satisfy(interval.contains).expect("within(\(interval))")
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is within the sequence `sequence`.
 
    - Parameter sequence: The sequence that the input is tested against.
 */
@warn_unused_result public func contains<S: SequenceType where S.Generator.Element: Equatable>(sequence: S) -> Parser<S.Generator.Element, S.Generator.Element> {
    return satisfy(sequence.contains).expect("contains(\(sequence))")
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is within the list `tokens`.
 
    - Parameter tokens: The list that the input is tested against.
*/
@warn_unused_result public func contains<Token: Equatable>(tokens: Token...) -> Parser<Token, Token> {
    return contains(tokens)
}

