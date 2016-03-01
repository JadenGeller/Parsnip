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
