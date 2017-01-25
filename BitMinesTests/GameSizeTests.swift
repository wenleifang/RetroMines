//
//  GameCoordinateTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class GameCoordinateTests: XCTestCase {
    func testEqual() {
		let first = GameCoordinate(x: 10, y: 10)
		let second = GameCoordinate(x: 10, y: 10)
		XCTAssertEqual(first, second)
    }
	
	func testNotEqual() {
		let first = GameCoordinate(x: 11, y: 10)
		let second = GameCoordinate(x: 10, y: 11)
		XCTAssertNotEqual(first, second)
	}
	
	func testEqualHashValue() {
		let first = GameCoordinate(x: 20, y: 42)
		let second = GameCoordinate(x: 20, y: 42)
		XCTAssertEqual(first.hashValue, second.hashValue)
	}
}
