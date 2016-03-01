//
//  Separating.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

// MARK: Separated

/**
    Constructs a `Parser` that will run `parser` 1 or more times, as many times as possible parsing `parser`
    separated by `delimiter`.

    - Parameter parser: The parser to run repeatedly.
    - Parameter delimiter: The parser to separate each occurance of `parser`.
*/
@warn_unused_result public func separatedBy1<Token, Result, Discard>(parser: Parser<Token, Result>, delimiter: Parser<Token, Discard>) -> Parser<Token, [Result]> {
    return prepend(parser, many(pair(delimiter, parser).map(right)))
}

/**
    Constructs a `Parser` that will run `parser` 0 or more times, as many times as possible parsing `parser`
    separated by `delimiter`.
 
    - Parameter parser: The parser to run repeatedly.
    - Parameter delimiter: The parser to separate each occurance of `parser`.
 */
@warn_unused_result public func separatedBy<Token, Result, Discard>(parser: Parser<Token, Result>, delimiter: Parser<Token, Discard>) -> Parser<Token, [Result]> {
    return separatedBy1(parser, delimiter: delimiter).otherwise([])
}

// MARK: Between

/**
    Constructs a `Parser` that will run `left` followed by `parser` followed by `right`,
    discarding the result from `left` and `right` and returning the result from `parser`.
 
    - Parameter leftDelimiter: The first parser whose result will be discarded.
    - Parameter rightDelimiter: The second parser whose result will be discarded.
    - Parameter parser: The parser that will be run between the other two parsers.
*/
public func between<Token, LeftIgnore, RightIgnore, Result>(leftDelimiter: Parser<Token, LeftIgnore>, _ rightDelimiter: Parser<Token, RightIgnore>, parse parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return pair(leftDelimiter, pair(parser, rightDelimiter).map(left)).map(right)
}

/**
    Constructs a `Parser` that will run `left` followed by `parser` followed by `right`,
    discarding the result from `left` and `right` and returning the result from `parser`.
 
    - Parameter side: The first and last parser whose result will be discarded.
    - Parameter parser: The parser that will be run between the other two parsers.
 */
public func between<Token, Ignore, Result>(side: Parser<Token, Ignore>, parse parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return between(side, side, parse: parser)
}
