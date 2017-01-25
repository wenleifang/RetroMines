//
//  BitMinesDataSource.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import Foundation
import UIKit

class BitMinesDataSource: NSObject, UICollectionViewDataSource, MineSpaceSelectable {
	static let kUnexploredCellIdentifier = "unexplored_cell"
	static let kExploredCellIdentifier = "explored_cell"

	var gameSpaceReloadable: GameSpaceReloadable? {
		set {
			gameModel.gameSpaceReloadable = newValue
		}
		get {
			return gameModel.gameSpaceReloadable
		}
	}
	
	var size: GameSize
	var gameModel: GameModel
	
	init(size: GameSize) {
		self.size = size
		gameModel = GameModel(size: size)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return size.w * size.h
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch gameModel.cellAppearance(indexPath: indexPath) {
			case .explored(let numberAdjacent):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier:BitMinesDataSource.kExploredCellIdentifier, for: indexPath) as! BitMinesCell
				switch numberAdjacent {
					case 0:
						cell.countImageView?.image = #imageLiteral(resourceName: "0_mine")
					case 1:
						cell.countImageView?.image = #imageLiteral(resourceName: "1_mine")
					case 2:
						cell.countImageView?.image = #imageLiteral(resourceName: "2_mine")
					case 3:
						cell.countImageView?.image = #imageLiteral(resourceName: "3_mine")
					case 4:
						cell.countImageView?.image = #imageLiteral(resourceName: "4_mine")
					default:
						cell.countImageView?.image = nil
				}
				return cell
			case .bomb:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier:BitMinesDataSource.kExploredCellIdentifier, for: indexPath) as! BitMinesCell
				cell.countImageView?.image = #imageLiteral(resourceName: "bomb")
				return cell
			case .flagged:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier:BitMinesDataSource.kExploredCellIdentifier, for: indexPath) as! BitMinesCell
				cell.countImageView?.image = #imageLiteral(resourceName: "flagged_space")
				return cell
			default:
				return collectionView.dequeueReusableCell(withReuseIdentifier:BitMinesDataSource.kUnexploredCellIdentifier, for: indexPath)
		}
	}
	
	func selectMineSpace(at indexPath: IndexPath) {
		gameModel.explore(at: indexPath)
	}

	func plantFlag(at indexPath: IndexPath) {
		gameModel.toggleFlag(at: indexPath)
	}
	
}
