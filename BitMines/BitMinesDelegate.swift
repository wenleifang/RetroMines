//
//  BitMinesDelegate.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import Foundation
import UIKit

class BitMinesDelegate: NSObject, UICollectionViewDelegate {
	var mineSpaceSelectable: MineSpaceSelectable
	
	init(mineSpaceSelectable: MineSpaceSelectable) {
		self.mineSpaceSelectable = mineSpaceSelectable
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		mineSpaceSelectable.selectMineSpace(at: indexPath)
	}
}
