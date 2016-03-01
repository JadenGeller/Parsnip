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
    @warn_unused_result public func raise(reason: ParseMessage<Token>) -> Parser {
        return peek { _ in throw reason }
    }
    
    /**
        Returns a `Parser` that fails regardless of successful parse.
    
        - Parameter message: The message to fail with.
    */
    @warn_unused_result public func fail(message: String = "fail") -> Parser {
        return raise(ParseMessage.Failure(message))
    }
    
    /**
        Returns a `Parser` that verifies that its result passes the condition before returning
        its result. If the result fails the condition, throws an error.
     
        - Parameter condition: The condition used to test the result.
     */
    @warn_unused_result public func require(condition: Result -> Bool) -> Parser {
        return peek { result in
            guard condition(result) else { throw ParseMessage<Token>.Failure("require") }
        }
    }
}
