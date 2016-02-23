//
//  ParseError.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/// An explanation as to why the parsing failed.
public enum ParseError: ErrorType {
    /// There is no input left to consume.
    case EndOfStream
    
    /// The input parsed did not fulfill a requirement. 
    case Failure(String)
    
    /// The parser failed to match the token with what was expected.
    case UnableToMatch(expected: String, actual: String)
}

/// A critical error that cannot be recovered from.
public struct Critical<Error: ErrorType>: ErrorType {
    /// The error.
    public let error: Error
    
    public init(_ error: Error) {
        self.error = error
    }
}

// MARK: Error Transformation

extension Parser {
    /**
        Constructs a `Parser` that, on `UnableToMatch` failure, will map the expected value using `transform`.
     
        - Parameter transform: The transform that constructs the new expected value.
    */
    @warn_unused_result public func mapExpected(transform: String -> String) -> Parser {
        return recover { error in
            guard case let .UnableToMatch(expected, actual) = error else { throw error }
            throw ParseError.UnableToMatch(expected: transform(expected), actual: actual)
        }
    }
    
    /**
        Constructs a `Parser` that, on `UnableToMatch` failure, replaces the expected value with the provided one.
     
        - Parameter value: The new expected value.
     */
    @warn_unused_result public func expect(value: String) -> Parser {
        return mapExpected{ _ in value }
    }
}
