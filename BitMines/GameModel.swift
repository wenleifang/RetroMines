//
//  GameModel.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import Foundation

public struct GameSize: Hashable {
	let w: Int
	let h: Int
	
	public var hashValue: Int {
		return w << 16 & h
	}
	
	public static func ==(lhs: GameSize, rhs: GameSize) -> Bool {
		return lhs.w == rhs.w && lhs.h == rhs.h
	}
}

public struct GameCoordinate: Hashable {
	let x: Int
	let y: Int
	
	public var hashValue: Int {
		return x << 16 & y
	}
	
	public static func ==(lhs: GameCoordinate, rhs: GameCoordinate) -> Bool {
		return lhs.x == rhs.x && lhs.y == rhs.y
	}
}

protocol GameSpaceReloadable: class {
	func reloadItems(at: [IndexPath])
}

protocol GameOverObserver: class {
	func game(isOver: Bool)
}

class GameModel {
	
	enum Space {
		case empty
		case mined
		
		var isMined: Bool {
			if case .mined = self {
				return true
			}
			return false
		}
	}
	
	enum Exploration {
		case unexplored
		case flagged
		case explored
		
		var isFlagged: Bool {
			if case .flagged = self {
				return true
			}
			return false
		}
	}
	
	enum SpaceAppearance: Equatable {
		case unexplored
		case flagged
		case explored(numberAdjacent: Int)
		case bomb
		
		static func ==(lhs: SpaceAppearance, rhs: SpaceAppearance) -> Bool {
			switch lhs {
				case .unexplored:
					if case .unexplored = rhs {
						return true
					}
				case .flagged:
					if case .flagged = rhs {
						return true
					}
				case .bomb:
					if case .bomb = rhs {
						return true
					}
				case .explored(let lhsNum):
					if case .explored(let rhsNum) = rhs, rhsNum == lhsNum {
						return true
					}
			}
			return false
		}
	}
	
	static let kDifficulty = UInt32.max / 8
//
//	enum Difficulty {
//		case easy
//		case medium
//		case hard
//		
//		var mineProbability: UInt32 {
//			get {
//				switch self {
//					case .easy:
//						return UInt32.max / 10
//					case .medium:
//						return UInt32.max / 8
//					case .hard:
//						return UInt32.max / 6
//				}
//			}
//		}
//	}
	
	var size: GameSize
	let spaces: [GameModel.Space]
	var explorations: [GameModel.Exploration]
	weak var gameSpaceReloadable: GameSpaceReloadable?
	weak var gameOverObserver: GameOverObserver? {
		didSet {
			gameOverObserver?.game(isOver: gameOver)
		}
	}
	
	var gameOver = false {
		didSet {
			gameOverObserver?.game(isOver: gameOver)
		}
	}
	
	var numSpaces: Int {
		return size.h * size.w
	}

	init(size: GameSize, spaces: [GameModel.Space]) {
		self.size = size
		var intArray:[Int] = []
		intArray += 0..<(size.w * size.h)
		explorations = intArray.map { _ in Exploration.unexplored }
		self.spaces = spaces
	}
	
//	convenience init(size: GameSize, difficulty: GameModel.Difficulty) {
	convenience init(size: GameSize) {
		let count = size.w * size.h
		var spaces: [GameModel.Space] = Array<GameModel.Space>(repeating: .empty, count: count)
		for i in 0..<(size.w * size.h) {
			let isMine = arc4random() < GameModel.kDifficulty
			if isMine {
				spaces[i] = .mined
			}
		}
		self.init(size: size, spaces: spaces)
	}
	
	func getCoordinate(forIndex index: Int) -> GameCoordinate {
		let x = index % size.w
		let y = index / size.w
		return GameCoordinate(x: x, y: y)
	}

	func getIndex(forCoordinate coordinate: GameCoordinate) -> Int {
		return coordinate.y * size.w + coordinate.x
	}

	
	func countAdjacentMines(at coordinate: GameCoordinate) -> Int {
		var count = 0
		for x in max(0, coordinate.x-1)...min(size.w-1, coordinate.x+1) {
			for y in max(0, coordinate.y-1)...min(size.h-1, coordinate.y+1) {
				let index = getIndex(forCoordinate: GameCoordinate(x: x, y: y))
				if spaces[index].isMined {
					count += 1
				}
			}
		}
		return count
	}

	func cellAppearance(indexPath: IndexPath) -> SpaceAppearance {
		let coordinate = getCoordinate(forIndex: indexPath.row)
		let index = indexPath.item
		let space = spaces[index]
		let exploration = explorations[index]
		switch exploration {
			case .unexplored:
				return .unexplored
			case .flagged:
				return .flagged
			case .explored:
				if space.isMined {
					return .bomb
				}
				else {
					return .explored(numberAdjacent: countAdjacentMines(at: coordinate))
				}
		}
	}
	
	private func revealAllMines(reloadedItems: inout [IndexPath]) {
		for index in 0..<numSpaces {
			if case .mined = spaces[index], case .unexplored = explorations[index] {
				explorations[index] = .explored
				reloadedItems.append(IndexPath(row: index, section: 0))
			}
		}
	}
	
	func explore(at indexPath: IndexPath) {
		if gameOver {
			return
		}
		var reloadedItems = [indexPath]
		var i = 0
		while i < reloadedItems.count {
			let cellIndexPath = reloadedItems[i]
			let cellIndex = cellIndexPath.item
			i += 1
			let coordinate = getCoordinate(forIndex: cellIndex)
			if case .unexplored = explorations[cellIndex] {
				explorations[cellIndex] = .explored
			}
			if spaces[cellIndex].isMined {
				revealAllMines(reloadedItems: &reloadedItems)
				gameOver = true
				break
			}
			if explorations[cellIndex].isFlagged {
				continue
			}
			
			if countAdjacentMines(at: coordinate) == 0 {
				let xs = max(0, coordinate.x-1)...min(size.w-1, coordinate.x+1)
				let ys = max(0, coordinate.y-1)...min(size.h-1, coordinate.y+1)
				for x in xs {
					for y in ys {
						let nextCoordinate = GameCoordinate(x: x, y: y)
						let nextIndex = getIndex(forCoordinate: nextCoordinate)
						let nextIndexPath = IndexPath(row: nextIndex, section: 0)
						if case .unexplored = explorations[nextIndex] {
							explorations[nextIndex] = .explored
							reloadedItems.append(nextIndexPath)
						}
					}
				}
			}
		}
		gameSpaceReloadable?.reloadItems(at: reloadedItems)
	}
	
	func toggleFlag(at indexPath: IndexPath) {
		if case .flagged = explorations[indexPath.item] {
			explorations[indexPath.item] = .unexplored
		} else if case .unexplored = explorations[indexPath.item] {
			explorations[indexPath.item] = .flagged
		}
		gameSpaceReloadable?.reloadItems(at: [indexPath])
	}
}
