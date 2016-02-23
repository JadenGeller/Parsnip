//
//  InputStream.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Spork

/// Represents the state of the parser. Stores the generator from which the subsequent symbols to parse
/// are obtained.
public final class InputStream<Token> {
    internal var backing: AnyForkableGenerator<Token>
    
    private(set) public var line: Int = 0
    private(set) public var column: Int = 0
    
    private init<Generator: ForkableGeneratorType where Generator.Element == Token>(_ generator: Generator) {
        self.backing = AnyForkableGenerator(generator)
    }
}

extension InputStream {
    /// Construct a `InputStream` from a forkable sequence. Provided as an optimization.
    public convenience init<Sequence: SequenceType where Sequence.Generator: ForkableGeneratorType, Sequence.Generator.Element == Token>(_ sequence: Sequence) {
        self.init(AnyForkableGenerator(sequence.generate()))
    }
    
    /// Construct a `InputStream` from any sequence.
    public convenience init<Sequence: SequenceType where Sequence.Generator.Element == Token>(_ sequence: Sequence) {
        self.init(AnyForkableGenerator(BufferingGenerator(bridgedFromGenerator: sequence.generate())))
    }
    
    /// Returns the next token from the generator, otherwise throws a `ParseError` if no more tokens are availible.
    public func read() throws -> Token {
        guard let next = backing.next() else { throw ParseError.EndOfStream  }
        
        return next
    }
}
