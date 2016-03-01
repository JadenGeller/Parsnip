//
//  ParsnipTests.swift
//  ParsnipTests
//
//  Created by Jaden Geller on 2/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Parsnip
import Spork

func XCTAssertThrows<T>(@noescape closure: () throws -> T, catching: ErrorType -> () = { _ in }) {
    do {
        let result = try closure()
        XCTFail("XCTAssertThrows failed: returned (\"\(result)\") instead of throwing.")
    } catch let error {
        catching(error)
    }
}

class ErrorTests: XCTestCase {
    
    func testCritical() {
        // This parser should fail if it reads in "directive " without any digits afterwards.
        // Otherwise, it will return the number afterwards or -1 if the word directive is not found.
        let directive = optional(Parser<Character, Int> { input in
            try string("directive ").run(input)
            return Int(String(try critical(many1(satisfy(("0"..."9").contains))).run(input)))!
        })
        
        XCTAssertEqual(81, try! directive.parse("directive 81".characters))
        XCTAssertEqual(nil, try! directive.parse("director blah".characters))
        XCTAssertThrows({ try directive.parse("directive blah".characters) })
    }
    
    func testErrorMessage() {
        XCTAssertThrows({ try string("hello").parse("hell".characters) }) { x in
            print(x)
        }
    }
}
