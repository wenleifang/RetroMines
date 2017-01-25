//
//  GameSizeTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class GameSizeTests: XCTestCase {
    func testEqual() {
		let first = GameSize(w: 10, h: 10)
		let second = GameSize(w: 10, h: 10)
		XCTAssertEqual(first, second)
    }
	
	func testNotEqual() {
		let first = GameSize(w: 11, h: 10)
		let second = GameSize(w: 10, h: 11)
		XCTAssertNotEqual(first, second)
	}
	
	func testEqualHashValue() {
		let first = GameSize(w: 20, h: 42)
		let second = GameSize(w: 20, h: 42)
		XCTAssertEqual(first.hashValue, second.hashValue)
	}
}
