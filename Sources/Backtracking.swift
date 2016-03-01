//
//  Backtracking.swift
//  Parsley
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

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

/**
    Constructs a `Parser` that runs `parser` without consuming any input.
 
    - Parameter parser: The parser to run.
*/
@warn_unused_result public func lookahead<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return Parser { input in
        let savedState = input.saveState()
        defer { input.restore(savedState) }
        return try parser.run(input)
    }
}

/**
    Constructs a parser that will succeed only if it is
*/
extension Parser {
    @warn_unused_result public func notFollowedBy<Ignore>(parser: Parser<Token, Ignore>) -> Parser<Token, Result> {
        parser
        return Parser { input in
            let result = try self.run(input)
            do {
                try lookahead(parser).run(input)
            } catch /* anything */ {
                return result
            }
            throw ParseMessage<Token>.Failure("notFollowedBy")
        }
    }
}
