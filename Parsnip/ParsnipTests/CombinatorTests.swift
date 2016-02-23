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

let lessThanFour: Parser<Int, Int> = satisfy{ $0 < 4 }
let even: Parser<Int, Int> = satisfy{ $0 % 2 == 0 }
let odd: Parser<Int, Int> = satisfy{ $0 % 2 == 1 }

class CombinatorTests: XCTestCase {
    
    func testMany() {
        XCTAssertEqual([0, 1, 2, 3], try! many(lessThanFour).parse(0...10))
        XCTAssertEqual([], try! many(lessThanFour).parse(8...10))
    }
    
    func testMany1() {
        XCTAssertEqual([0, 1, 2, 3], try! many1(lessThanFour).parse(0...10))
        XCTAssertEqual([3], try! many1(lessThanFour).parse(3...10))
        XCTAssertNil(try? many1(lessThanFour).parse(8...10))
    }
    
    func testCoalesce() {
        XCTAssertTrue(try! 12 == coalesce(token(3), token(5), token(12)).parse([12, 3]))
        XCTAssertTrue(try! 3 == coalesce(token(3), token(5), token(12)).parse([3, 12]))
        XCTAssertTrue(try! 3 == coalesce(token(7), token(12), token(3)).parse([3, 12]))
        XCTAssertNil(try? coalesce(token(3), token(5), token(12)).parse([7, 3, 12]))
    }
    
    func testTerminating() {
        do {
            _ = try terminating(sequence(token(0), token(1))).parse(0...1)
        } catch {
            XCTFail()
        }
        do {
            _ = try terminating(sequence(token(0), token(1))).parse(0...2)
            XCTFail()
        } catch {
        }
    }
}
