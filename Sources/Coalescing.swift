//
//  Coalescing.swift
//  Parsley
//
//  Created by Jaden Geller on 1/12/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that will parse with the first parser in `parsers` that succeeds.

    - Parameter parsers: The sequence of parsers to attempt.
    - Throws: If all parsers fail, propogates the error thrown by the final parser.
*/
@warn_unused_result public func coalesce<Token, Result, S: SequenceType where S.Generator.Element == Parser<Token, Result>> (parsers: S) -> Parser<Token, Result> {
    return Parser { input in
        var reasons: [ParseError<Token>] = []
        for parser in parsers {
            do {
                return try attempt(parser).run(input)
            } catch let error as ParseError<Token> {
                reasons.append(error)
            }
        }
        throw ParseError(combine: reasons)
    }
}

/**
    Constructs a `Parser` that will parse with the first element of `parsers` that succeeds.
 
    - Parameter parsers: A variadic list of parsers to attempt.
*/
@warn_unused_result public func coalesce<Token, Result>(parsers: (Parser<Token, Result>)...) -> Parser<Token, Result> {
    return coalesce(parsers)
}

/**
    Constructs a `Parser` that will parse with `rightParser` if and only if `leftParser` fails.
    Note that the construct parser will result in the same type as both other parsers.
 
    - Parameter leftParser: The parser to run first.
    - Parameter rightParser: The parser to run whenever the first parser fails.
*/
@warn_unused_result public func ??<Token, Result>(leftParser: Parser<Token, Result>, rightParser: Parser<Token, Result>) -> Parser<Token, Result> {
    return coalesce(leftParser, rightParser)
}


@warn_unused_result public func ??<Token, Result>(leftParser: Parser<Token, Result>, rightValue: Result) -> Parser<Token, Result> {
    return leftParser ?? pure(rightValue)
}

/**
    Constructs a `Parser` that will attempt to parse with `parser`, but will backtrack and return `nil` on failure

    - Parameter parser: The parser to run.
*/
@warn_unused_result public func optional<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result?> {
    return parser.map(Optional.Some).otherwise(nil)
}

/**
Constructs a `Parser` that will attempt to parse with `parser`, but will backtrack and return `nil` on failure

- Parameter parser: The parser to run.
*/
@warn_unused_result public func optional<Token, Result>(parser: Parser<Token, [Result]>) -> Parser<Token, [Result]> {
    return parser.otherwise([])
}


