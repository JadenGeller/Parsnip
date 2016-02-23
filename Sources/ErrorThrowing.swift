//
//  ErrorThrowing.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

extension Parser {
    /**
     Returns a `Parser` that fails with the given `error` on successful parse.
     
     - Parameter error: The error that will be thrown on successful parse.
     */
    @warn_unused_result public func raise(error: ParseError) -> Parser {
        return peek { _ in
            throw error
        }
    }
    
    /**
     Returns a `Parser` that fails regardless of successful parse.
     */
    @warn_unused_result public func fail() -> Parser {
        return raise(ParseError.Failure("fail"))
    }
    
    /**
     Returns a `Parser` that verifies that its result passes the condition before returning
     its result. If the result fails the condition, throws an error.
     
     - Parameter condition: The condition used to test the result.
     */
    @warn_unused_result public func require(condition: Result -> Bool) -> Parser {
        return peek { result in
            if !condition(result) { throw ParseError.UnableToMatch(expected: "unknown", actual: "\(result)") }
        }
    }
}
