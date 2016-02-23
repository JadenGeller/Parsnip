//
//  ErrorRecovery.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

extension Parser {
    /**
        Constructs a `Parser` that, on error, catches the error and attempts to recover by running the `Parser` obtained
        from passing the error to `recovery`. Note that critical errors will pass through.
     
        - Parameter recovery: A function that, given the error, will return a new parser to use.
    */
    @warn_unused_result public func recover(recovery: ParseError throws -> Parser<Token, Result>) -> Parser {
        return Parser { input in
            do {
                return try self.run(input)
            } catch let error as ParseError {
                return try recovery(error).run(input)
            }
        }
    }
    
    /**
        Constructs a `Parser` that catches an error and returns `recovery` instead.
     
        - Parameter recovery: Result to be returned in case of an error.
    */
    @warn_unused_result public func otherwise(recovery: Result) -> Parser {
        return attempt(self).recover { _ in pure(recovery) }
    }
}

