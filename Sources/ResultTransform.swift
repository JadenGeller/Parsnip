//
//  ResultTransform.swift
//  Parsnip
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

extension Parser {
    /**
        Returns a `Parser` that, on successful parse, continues parsing with the parser resulting
        from mapping `transform` over its result value; returns the result of this new parser.
     
        Can be used to chain parsers together sequentially.
     
        - Parameter transform: The transform to map over the result.
     */
    @warn_unused_result public func flatMap<V>(transform: Result throws -> Parser<Token, V>) -> Parser<Token, V> {
        return Parser<Token, V> { input in
            return try transform(self.run(input)).run(input)
        }
    }
    
    /**
        Returns a `Parser` that, on successful parse, returns the result of mapping `transform`
        over its previous result value
     
        - Parameter transform: The transform to map over the result.
    */
    @warn_unused_result public func map<V>(transform: Result throws -> V) -> Parser<Token, V> {
        return Parser<Token, V> { state in
            return try transform(self.run(state))
        }
    }
    
    /**
        Returns a `Parser` that calls the callback `glimpse` before returning its result.
     
        - Parameter glimpse: Callback that recieves the parser's result as input.
     */
    @warn_unused_result public func peek(glimpse: Result throws -> ()) -> Parser<Token, Result> {
        return map { result in
            try glimpse(result)
            return result
        }
    }

    /**
        Returns a `Parser` that, on successful parse, discards its previous result and returns `value` instead.
     
        - Parameter value: The value to return on successful parse.
    */
    @warn_unused_result public func replace<V>(value: V) -> Parser<Token, V> {
        return map { _ in value }
    }
    
    /**
        Returns a `Parser` that, on successful parse, discards its result.
    */
    @warn_unused_result public func discard() -> Parser<Token, ()> {
        return replace(())
    }
}
