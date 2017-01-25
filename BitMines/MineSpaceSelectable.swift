//
//  MineSpaceSelectable.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/21/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import Foundation
import UIKit

protocol MineSpaceSelectable {
	func selectMineSpace(at indexPath: IndexPath)
	func plantFlag(at indexPath: IndexPath)
}
