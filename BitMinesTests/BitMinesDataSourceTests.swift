//
//  BitMinesDataSourceTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/21/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class BitMinesDataSourceTests: XCTestCase {
    var dataSource: BitMinesDataSource!
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		dataSource = BitMinesDataSource(size: GameSize(w: 10, h: 11))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameSize() {
		XCTAssertEqual(10, dataSource.gameModel.size.w)
		XCTAssertEqual(11, dataSource.gameModel.size.h)
    }
	
	func testPlantFlag() {
		dataSource.plantFlag(at: IndexPath(item: 11, section: 0))
		XCTAssertEqual(GameModel.Exploration.flagged, dataSource.gameModel.explorations[11])
	}
	
	func testSelectMineSpace() {
		dataSource.selectMineSpace(at: IndexPath(item: 90, section: 0))
		XCTAssertEqual(GameModel.Exploration.explored, dataSource.gameModel.explorations[90])
	}
    
}
