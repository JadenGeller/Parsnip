//
//  Text.swift
//  Parsley
//
//  Created by Jaden Geller on 1/12/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Spork

extension Parser where Result: SequenceType, Result.Generator.Element == Character {
    /**
        Converts a parser that results in a sequence of characters into a parser that
        results in a String.
    */
    @warn_unused_result public func stringify() -> Parser<Token, String> {
        return map { String($0) }
    }
}

/**
    Construct a `Parser` that matches a given character.
 
    - Parameter character: The character to match against.
*/
@warn_unused_result public func character(character: Character) -> Parser<Character, Character> {
    return token(character).expect("\"\(character)\"")
}

/**
    Constructs a `Parser` that matches a given string of text.
 
    - Parameter text: The string of text to match against.
*/
@warn_unused_result public func string(text: String) -> Parser<Character, [Character]> {
    return sequence(text.characters.map(token)).expect("\"\(text)\"")
}

/**
 Constructs a `Parser` that consumes a single token and returns the token
 if it is within the string `text`.
 
 - Parameter text: The `String` that the input is tested against.
 */
@warn_unused_result public func within(text: String) -> Parser<Character, Character> {
    return within(text.characters).expect("within(\(text))")
}

/**
    A `Parser` that succeeds upon consuming a letter from the English alphabet.
 */
public let letter: Parser<Character, Character> = between("A"..."z").expect("letter")

/**
    A `Parser` that succeeds upon consuming an Arabic numeral.
*/
public let digit: Parser<Character, Character> = between("0"..."9").expect("digit")

/**
    Constructs a `Parser` that succeeds upon consuming a space character.
*/
public let space: Parser<Character, Character> = token(" ").expect("space")

/**
    Constructs a `Parser` that skips zero or more space characters.
*/
public let spaces: Parser<Character, ()> = many(space).discard()

/**
    Constructs a `Parser` that succeeds upon consuming a new line character.
*/
public let newLine: Parser<Character, Character> = token("\n").expect("newline")

/**
    Constructs a `Parser` that succeeds upon consuming a tab character.
*/
public let tab: Parser<Character, Character> = token("\t").expect("tab")

/**
    Constructs a `Parser` that skips zero or more space characters.
*/
public let whitespace: Parser<Character, ()> = many(space ?? newLine ?? tab).discard()

/**
    Constructs a `Parser` that succeeds upon consuming an uppercase letter.
*/
public let uppercaseLetter: Parser<Character, Character> = between("A"..."Z").expect("uppercaseLetter")

/**
 Constructs a `Parser` that succeeds upon consuming an lowercase letter.
 */
public let lowercaseLetter: Parser<Character, Character> = between("a"..."z").expect("lowercaseLetter")

