//
//  Repeating.swift
//  Parsley
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that will run `parser` 0 or more times, as many times as possible,
    and will result in an array of the results from each invocation.

    - Parameter parser: The parser to run repeatedly.
*/
@warn_unused_result public func many<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return Parser { input in
        var results = [Result]()
        do {
            while true {
                results.append(try attempt(parser).run(input))
            }
        }
        catch _ as ParseError<Token> { }
        return results
    }
}

/**
    Constructs a `Parser` that will run `parser` 1 or more times, as many times as possible,
    and will result in an array of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
 */
@warn_unused_result public func many1<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return parser.flatMap { firstResult in
        many(parser).map { otherResults in
            [firstResult] + otherResults
        }
    }
}

/**
    Constructs a `Parser` that will run `parser` exactly `count` times and will result in an array
    of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
    - Parameter exactCount: The number of times to run `parser`.
 */
@warn_unused_result public func repeated<Token, Result>(parser: Parser<Token, Result>, exactCount: Int) -> Parser<Token, [Result]> {
    return Parser { input in
        var results = [Result]()
        for _ in 0..<exactCount {
            results.append(try parser.run(input))
        }
        return results
    }
}

/**
    Constructs a `Parser` that will run `parser` a maximum of `count` times and will result in an array
    of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
    - Parameter maxCount: The maximum number of times to run `parser`.
 */
@warn_unused_result public func repeated<Token, Result>(parser: Parser<Token, Result>, maxCount: Int) -> Parser<Token, [Result]> {
    return Parser { input in
        var results = [Result]()
        while results.count < maxCount {
            do {
                results.append(try attempt(parser).run(input))
            }
            catch _ as ParseError<Token> {
                break
            }
        }
        return results
    }
}

/**
    Constructs a `Parser` that will run `parser` a minimum of `count` times and will result in an array
    of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
    - Parameter minCount: The minimum number of times to run `parser`.
 */
@warn_unused_result public func repeated<Token, Result>(parser: Parser<Token, Result>, minCount: Int) -> Parser<Token, [Result]> {
    return pair(repeated(parser, exactCount: minCount), many(parser)).map(+)
}

/**
    Constructs a `Parser` that will run `parser` a number of times within `interval` and will result in an array
    of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
    - Parameter interval: The interval describing the allowed number of times to run parser.
 */
@warn_unused_result public func repeated<Token, Result>(parser: Parser<Token, Result>, betweenCount interval: ClosedInterval<Int>) -> Parser<Token, [Result]> {
    return pair(repeated(parser, exactCount: interval.start), repeated(parser, maxCount: interval.end - interval.start)).map(+)
}

/**
    Constructs a `Parser` that will run `parser` a number of times within `interval` and will result in an array
    of the results from each invocation.
 
    - Parameter parser: The parser to run repeatedly.
    - Parameter interval: The interval describing the allowed number of times to run parser.
 */
@warn_unused_result public func repeated<Token, Result>(parser: Parser<Token, Result>, betweenCount interval: HalfOpenInterval<Int>) -> Parser<Token, [Result]> {
    return repeated(parser, betweenCount: interval.start...interval.end.predecessor())
}

