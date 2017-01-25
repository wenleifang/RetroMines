//
//  GameModelSpaceTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class GameModelSpaceTests: XCTestCase {
    
    func testIsMined() {
		XCTAssertTrue(GameModel.Space.mined.isMined)
	}

    func testIsNotMined() {
		XCTAssertFalse(GameModel.Space.empty.isMined)
	}

}
