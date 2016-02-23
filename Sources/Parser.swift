//
//  Parser.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Spork

/// A parser that consumes input and returns a result.
public struct Parser<Token, Result> {
    /// The lambda implementation of a parser.
    public typealias Implementation = InputStream<Token> throws -> Result
    internal let implementation: Implementation
    
    /// Construct a `Parser` that will run `implementation`.
    public init(_ implementation: Implementation) {
        self.implementation = implementation
    }
    
    /**
        Runs the parser on the passed in `input`, mutating the stream.
     
        - Parameter input: The `InputStream` representing input to be parsed.
        - Throws: `ParseError` if unable to parse.
        - Returns: The resulting parsed value.
    */
    public func run(input: InputStream<Token>) throws -> Result {
        return try implementation(input)
    }
}

// MARK: Parsing

extension Parser {
    /**
        Runs the parser on the passed in `sequence`.
     
        - Parameter sequence: The sequence to be parsed.
     
        - Throws: `ParseError` if unable to parse.
        - Returns: The resulting parsed value.
    */
    @warn_unused_result public func parse<Sequence: SequenceType where Sequence.Generator: ForkableGeneratorType, Sequence.Generator.Element == Token>(sequence: Sequence) throws -> Result {
        return try run(InputStream(sequence))
    }
    
    /**
        Runs the parser on the passed in `sequence`.
     
        - Parameter sequence: The sequence to be parsed.
     
        - Throws: `ParseError` if unable to parse.
        - Returns: The resulting parsed value.
    */
    @warn_unused_result public func parse<Sequence: SequenceType where Sequence.Generator.Element == Token>(sequence: Sequence) throws -> Result {
        return try run(InputStream(sequence))
    }
}
