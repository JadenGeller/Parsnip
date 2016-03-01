//
//  BaseTests.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import XCTest
import Parsnip
import Spork

#if false
    
struct Scheme {
    static let bareWord = prepend(
        letter,
        many1(letter ?? digit)
    ).expect("bareWord")
    
    static let integerLiteral = prepend(
        within("+-".characters).otherwise("+"),
        many1(digit)
    ).expect("integerLiteral")
    
    static let floatingPointLiteral = concat(
        integerLiteral,
        character(".").map{ [$0] },
        many(digit)
    ).expect("floatingPointLiteral")
    
    static let stringLiteral = between(character("\""), parseFew: string("\\\"") ?? any().map { [$0] }).map { $0.flatten() }
    
    static let symbol = elementOf("(", ")", "+", "-", "*", "/", "[", "]").expect("symbol")
    
    static let comment = recursive { (parser: Parser<Character, ()>) in
        sequence(
            string("/*").discard(),
            few(parser ?? any().discard(), then: string("/*")).discard()
        ).discard()
    }
}

class SchemeTests: XCTestCase {
    func testBareWord() {
        XCTAssertEqual("blah34daDa", try? terminating(Scheme.bareWord).stringify().parse("blah34daDa".characters))
        XCTAssertNil(try? terminating(Scheme.bareWord).stringify().parse(" blah34daDa".characters))
        XCTAssertNil(try? terminating(Scheme.bareWord).stringify().parse("35add".characters))
    }
    
    func testIntegerLiteral() {
        XCTAssertEqual("13502", try? terminating(Scheme.integerLiteral).stringify().parse("13502".characters))
        XCTAssertEqual("+12", try? terminating(Scheme.integerLiteral).stringify().parse("+12".characters))
        XCTAssertEqual("-0", try? terminating(Scheme.integerLiteral).stringify().parse("-0".characters))
        XCTAssertNil(try? terminating(Scheme.integerLiteral).stringify().parse("--32".characters))
        XCTAssertNil(try? terminating(Scheme.integerLiteral).stringify().parse("32a".characters))
    }
    
    func testFloatingPointLiteral() {
        XCTAssertEqual("13.502", try? terminating(Scheme.floatingPointLiteral).stringify().parse("13.502".characters))
        XCTAssertEqual("+0.12", try? terminating(Scheme.floatingPointLiteral).stringify().parse("+0.12".characters))
        XCTAssertEqual("-0.", try? terminating(Scheme.floatingPointLiteral).stringify().parse("-0.".characters))
        XCTAssertNil(try? terminating(Scheme.floatingPointLiteral).stringify().parse("3.-32".characters))
        XCTAssertNil(try? terminating(Scheme.floatingPointLiteral).stringify().parse(".3".characters))
    }
    
    func testStringLiteral() {
        XCTAssertEqual("Hello world!!!:D:D3.1415", try? terminating(Scheme.stringLiteral).stringify().parse("\"Hello world!!!:D:D3.1415\"".characters))
        XCTAssertEqual("Hello world\\\"!!!:D:D3.1415", try! terminating(Scheme.stringLiteral).stringify().parse("\"Hello world\\\"!!!:D:D3.1415\"".characters))
        XCTAssertNil(try? terminating(Scheme.stringLiteral).stringify().parse("\"Hello world\"!!!:D:D3.1415\"".characters))
    }
}

#endif