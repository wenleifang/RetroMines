//
//  GameModelTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
@testable import BitMines

class GameModelTests: XCTestCase, GameSpaceReloadable {
    var gameModel: GameModel!
	var modifiedCells: [IndexPath] = []
	let mineLocations = [
		(x: 5, y: 0),
		(x: 0, y: 5),
		(x: 4, y: 9),
		(x: 5, y: 9),
		(x: 6, y: 9),
		(x: 7, y: 0),
		(x: 8, y: 0),
		(x: 9, y: 0),
		(x: 7, y: 1),
		(x: 9, y: 1),
		(x: 7, y: 2),
		(x: 8, y: 2),
		(x: 9, y: 2),
		(x: 0, y: 6),
		(x: 1, y: 6),
		(x: 2, y: 6),
		(x: 2, y: 7),
		(x: 2, y: 8),
		(x: 2, y: 9),
	]
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let size = GameSize(w: 10, h: 10)
		let count = size.w * size.h
		var spaces = Array<GameModel.Space>(repeating: .empty, count: count)
		for mineLocation in mineLocations {
			let index = mineLocation.x + mineLocation.y * size.w
			spaces[index] = .mined
		}

		gameModel = GameModel(size: size, spaces: spaces)
		gameModel.gameSpaceReloadable = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		gameModel = nil
		
        super.tearDown()
    }
	
	func reloadItems(at indexPaths: [IndexPath]) {
		modifiedCells = indexPaths.sorted(by: <)
	}
	
	func doExploration(x: Int, y: Int) -> (xs: [Int], ys: [Int]) {
		let coordinate = GameCoordinate(x: x, y: y)
		let index = gameModel.getIndex(forCoordinate: coordinate)
		let indexPath = IndexPath(row: index, section: 0)
		gameModel.explore(at: indexPath)
		let ys = modifiedCells.map { indexPath -> Int in
			let coordinate = gameModel.getCoordinate(forIndex: indexPath.row)
			return coordinate.y
		}
		let xs = modifiedCells.map { indexPath -> Int in
			let coordinate = gameModel.getCoordinate(forIndex: indexPath.row)
			return coordinate.x
		}
		return (xs: xs, ys: ys)
	}
	
	func testExplore() {
		let explored = doExploration(x: 0, y: 9)
		XCTAssertEqual([0, 1, 0, 1, 0, 1], explored.xs)
		XCTAssertEqual([7, 7, 8, 8, 9, 9], explored.ys)
	}
	
	func doFlagTest(x: Int, y: Int, numToggles: Int = 1) -> (xs: [Int], ys: [Int]) {
		let coordinate = GameCoordinate(x: x, y: y)
		let index = gameModel.getIndex(forCoordinate: coordinate)
		let indexPath = IndexPath(row: index, section: 0)
		for _ in 0..<numToggles {
			gameModel.toggleFlag(at: indexPath)
			XCTAssertEqual([indexPath], modifiedCells)
		}
		return doExploration(x: 0, y: 9)
	}
	
	func testToggleFlagOn() {
		let explored = doFlagTest(x: 0, y: 7, numToggles: 1)
		XCTAssertEqual([1, 0, 1, 0, 1], explored.xs)
		XCTAssertEqual([7, 8, 8, 9, 9], explored.ys)
	}
	
	func testToggleFlagOff() {
		let explored = doFlagTest(x: 0, y: 7, numToggles: 2)
		XCTAssertEqual([0, 1, 0, 1, 0, 1], explored.xs)
		XCTAssertEqual([7, 7, 8, 8, 9, 9], explored.ys)
	}
	
	func testExploreFlaggedSpace() {
		let explored = doFlagTest(x: 0, y: 9, numToggles: 1)
		XCTAssertEqual([0], explored.xs)
		XCTAssertEqual([9], explored.ys)
		XCTAssertEqual(GameModel.SpaceAppearance.flagged, gameModel.cellAppearance(indexPath: IndexPath(row: 90, section: 0)))
	}
	
    func testCount0AdjacentMinesInCorner() {
		XCTAssertEqual(0, gameModel.countAdjacentMines(at: GameCoordinate(x: 0, y: 0)))
    }
    
    func testCount0AdjacentMinesInField() {
		XCTAssertEqual(0, gameModel.countAdjacentMines(at: GameCoordinate(x: 7, y: 7)))
    }
    
    func testCount8AdjacentMinesInField() {
		XCTAssertEqual(8, gameModel.countAdjacentMines(at: GameCoordinate(x: 8, y: 1)))
    }
	
	func testCoordinateForIndex() {
		XCTAssertEqual(GameCoordinate(x: 5, y: 5), gameModel.getCoordinate(forIndex: 55))
	}
	
	func testIndexPathForCoordinate() {
		XCTAssertEqual(55, gameModel.getIndex(forCoordinate: GameCoordinate(x: 5, y: 5)))
	}
	
	func testCellAppearance() {
		XCTAssertEqual(GameModel.SpaceAppearance.unexplored, gameModel.cellAppearance(indexPath: IndexPath(item: 55, section: 0)))
	}
	
	func testExploredCellAppearance() {
		let indexPath = IndexPath(item: 55, section: 0)
		gameModel.explore(at: indexPath)
		let cellAppearance = gameModel.cellAppearance(indexPath: indexPath)
		XCTAssertEqual(GameModel.SpaceAppearance.explored(numberAdjacent: 0), cellAppearance)
	}

	func testExploredMinedCellAppearance() {
		let indexPath = IndexPath(item: 5, section: 0)
		gameModel.explore(at: indexPath)
		let cellAppearance = gameModel.cellAppearance(indexPath: indexPath)
		XCTAssertEqual(GameModel.SpaceAppearance.bomb, cellAppearance)
	}
	
	func testMineProbability() {
		let size = gameModel.size
		gameModel = GameModel(size: size)
		var numMines = 0
		let numSpaces = size.h * size.w
		for index in 0..<numSpaces {
			if gameModel.spaces[index].isMined {
				numMines += 1
			}
		}
		XCTAssert(numMines < (numSpaces - numMines), "More spaces than mines")
	}
}
