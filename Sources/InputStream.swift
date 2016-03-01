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
    internal var base: AnyForkableGenerator<Token>
    internal var index: Int
    
    private init<Generator: ForkableGeneratorType where Generator.Element == Token>(_ base: Generator) {
        self.index = 0
        self.base = AnyForkableGenerator(base)
    }
}

extension InputStream: GeneratorType {
    /// Returns the next token from the generator, otherwise throws a `ParseError` if no more tokens are availible.
    public func next() -> Token? {
        guard let value = base.next() else { return nil }
        index += 1
        return value
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
}
