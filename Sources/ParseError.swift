//
//  ParseError.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct ParseError<Token>: ErrorType {
    public let index: Int
    public let actual: Token?
    public let reason: ParseMessage<Token>
    
    internal init(index: Int, actual: Token?, reason: ParseMessage<Token>) {
        self.index = index
        self.actual = actual
        self.reason = reason
    }
}

extension ParseError {
    public init(combine errors: [ParseError]) {
        precondition(!errors.isEmpty)
        let maxElement = errors.maxElement { $0.index < $1.index }!
        let longestErrors = errors.filter { $0.index == maxElement.index }
        
        self = ParseError(index: maxElement.index, actual: maxElement.actual, reason: ParseMessage(combine: longestErrors.map{ $0.reason }))
    }
}

extension ParseError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self.reason {
        case .UnableToMatch(let failures):
            return "ParseError(failures: \(failures))"
        case .Failure(let message):
            return "Failure(\(message))"
        }
    }
}

extension Parser {
    /**
        Constructs a `Parser` that, on `UnableToMatch` failure, replaces the expected value with the provided one.
     
        - Parameter value: The new expected value.
     */
    @warn_unused_result public func expect(name: String) -> Parser {
        return Parser { input in
            do {
                return try self.run(input)
            } catch _ as ParseError<Token> {
                throw ParseMessage<Token>.UnableToMatch([.NamedParser(name)])
            }
        }
    }
}
