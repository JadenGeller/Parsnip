//
//  Backtracking.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

// MARK: Terminating

/**
    Constructs a `Parser` that will run `parser` and ensure that no input remains upon `parser`'s completion.
    If any input does remain, an error is thrown.
 
    - Parameter parser: The parser to be run.
*/
public func terminating<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return parser.flatMap { result in end().replace(result) }
}

// MARK: Backtracking

/**
    Constructs a `Parser` that will, on failure, raise a critical error that will not be caught.
 
    - Parameter parser: The parser whose errors should be elevated to critical.
*/
@warn_unused_result public func critical<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    parser
    return parser.recover { error in throw Critical(error) }
}

/**
    Constructs a `Parser` that runs attempts to run `parser` and backtracks on failure.
    On successful parse, this parser returns the result of `parse`; on failure, this parser
    catches the error, rewinds the `Stream` back to the state before the parse, and
    rethrows the error. Note that the parser will not backtrack on critical errors.

    - Parameter parser: The parser to run with backtracking on failure.
*/
@warn_unused_result public func attempt<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    parser
    return Parser { input in
        let savedState = input.saveState()
        return try parser.recover { error in
            input.restore(savedState)
            throw error
        }.run(input)
    }
}

// MARK: Coalescing

/**
    Constructs a `Parser` that will parse with the first parser in `parsers` that succeeds.

    - Parameter parsers: The sequence of parsers to attempt.
    - Throws: If all parsers fail, propogates the error thrown by the final parser.
*/
@warn_unused_result public func coalesce<Token, Result, S: SequenceType where S.Generator.Element == Parser<Token, Result>>
    (parsers: S) -> Parser<Token, Result> {
        return Parser { input in
            var previousError = ParseError.Failure("coalesce")
            for parser in parsers {
                do {
                    return try attempt(parser).run(input)
                } catch let error as ParseError {
                    previousError = error
                }
            }
            throw previousError
        }
}

/**
    Constructs a `Parser` that will parse with the first element of `parsers` that succeeds.
 
    - Parameter parsers: A variadic list of parsers to attempt.
*/
@warn_unused_result public func coalesce<Token, Result>(parsers: (Parser<Token, Result>)...) -> Parser<Token, Result> {
    return coalesce(parsers)
}

// MARK: Optional

/**
    Constructs a `Parser` that will attempt to parse with `parser`, but will backtrack and return `nil` on failure

    - Parameter parser: The parser to run.
*/
@warn_unused_result public func optional<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result?> {
    return parser.map(Optional.Some).otherwise(nil)
}

// MARK: Sequencing

/**
    Constructs a `Parser` that will parse will each element of `parsers`, sequentially. Parsing only succeeds if every
    parser succeeds, and the resulting parser returns an array of the results.

    - Parameter parsers: The sequence of parsers to sequentially run.
*/
public func sequence<Token, Result, Sequence: SequenceType where Sequence.Generator.Element == Parser<Token, Result>> (parsers: Sequence) -> Parser<Token, [Result]> {
    return Parser { input in
        var results = [Result]()
        for parser in parsers {
            results.append(try parser.run(input))
        }
        return results
    }
}

/**
    Constructs a `Parser` that will run the passed-in parsers sequentially. Parsing only succeeds if both
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
@warn_unused_result public func pair<Token, LeftResult, RightResult>(leftParser: Parser<Token, LeftResult>, _ rightParser: Parser<Token, RightResult>) -> Parser<Token, (LeftResult, RightResult)> {
    return leftParser.flatMap { a in
        rightParser.map { b in
            return (a, b)
        }
    }
}

/**
    Constructs a `Parser` that will parse will each element of `parsers`, sequentially. Parsing only succeeds if every
    parser succeeds, and the resulting parser returns an array of the results.
 
    - Parameter parsers: The variadic list of parsers to sequentially run.
*/
public func sequence<Token, Result>(parsers: Parser<Token, Result>...) -> Parser<Token, [Result]> {
    return sequence(parsers)
}

// MARK: Repeating

/**
    Constructs a `Parser` that will run `parser` 0 or more times, as many times as possible,
    and will result in an array of the results from each invocation.

    - Parameter parser: The parser to run repeatedly.
*/
@warn_unused_result public func many<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return Parser { input in
        var results = [Result]()
        do {
            while true {
                results.append(try attempt(parser).run(input))
            }
        }
        catch _ as ParseError { }
        return results
    }
}

/**
    Constructs a `Parser` that will run `parser` 1 or more times, as many times as possible,
    and will result in an array of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
 */
@warn_unused_result public func many1<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return parser.flatMap { firstResult in
        many(parser).map { otherResults in
            [firstResult] + otherResults
        }
    }
}

// MARK: Recursive

/**
    Constructs a `Parser` that is able to recurse on itself.

    - Parameter recurse: A function that receives its `Parser` return value as an argument.
*/
@warn_unused_result public func recursive<Token, Result>(recurse: Parser<Token, Result> -> Parser<Token, Result>) -> Parser<Token, Result> {
    return Parser { input in
        try fixedPoint{ (implementation: Parser<Token, Result>.Implementation) in
            return recurse(Parser(implementation)).implementation
        }(input)
    }
}

/**
    A function that enables anonymous functions to recurse on themselves.

    - Parameter recurse: A function that recieves itself as an argument.
*/
@warn_unused_result private func fixedPoint<T, V>(recurse: (T throws -> V) -> (T throws -> V)) -> T throws -> V {
    return { try recurse(fixedPoint(recurse))($0) }
}

