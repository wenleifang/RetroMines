//
//  GameModelSpaceAppearanceTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class GameModelSpaceAppearanceTests: XCTestCase {
    
	func testBombEquality() {
		XCTAssertEqual(GameModel.SpaceAppearance.bomb, GameModel.SpaceAppearance.bomb)
	}
	
	func testTwoAdjacentEquality() {
		XCTAssertEqual(GameModel.SpaceAppearance.explored(numberAdjacent: 2), GameModel.SpaceAppearance.explored(numberAdjacent: 2))
	}
		
	func testInequality() {
		XCTAssertNotEqual(GameModel.SpaceAppearance.flagged, GameModel.SpaceAppearance.unexplored)
	}

}
