//
//  GameModelExplorationTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class GameModelExplorationTests: XCTestCase {
	
    func testIsFlagged() {
		XCTAssertTrue(GameModel.Exploration.flagged.isFlagged)
	}
	
    func testUnexploredIsNotFlagged() {
		XCTAssertFalse(GameModel.Exploration.unexplored.isFlagged)
	}
		
    func testExploredIsNotFlagged() {
		XCTAssertFalse(GameModel.Exploration.explored.isFlagged)
	}

}
