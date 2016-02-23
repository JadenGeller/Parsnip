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

class ErrorTests: XCTestCase {
    func testCritical() {
        let directive = Parser<Character, [Character]> { input in
            try sequence("directive ".characters.map(token)).run(input)
            return try critical(many1(satisfy(("0"..."9").contains))).run(input)
        }
        let either = coalesce(directive, many1(any()))
        
        XCTAssertEqual(["8", "1"], try! either.parse("directive 81".characters))
        XCTAssertEqual(["d", "i", "r", "e", "c", "t", "o", "r"], try! either.parse("director".characters))
        XCTAssertEqual(["d", "i", "r", "e", "c", "t", "o", "r"], try! either.parse("director".characters))
    }
}
