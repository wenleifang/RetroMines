//
//  ViewController.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/19/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

extension UICollectionView: GameSpaceReloadable {}

class BitMinesViewController: UIViewController, GameOverObserver {

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var gameButton: UIButton!
	
	var dataSource: BitMinesDataSource?
	var delegate: BitMinesDelegate?
	var longPressRecognizer: UILongPressGestureRecognizer?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
		self.collectionView.addGestureRecognizer(longPressRecognizer)
		self.longPressRecognizer = longPressRecognizer
		
		gameButton.setImage(#imageLiteral(resourceName: "sad_button"), for: .selected)
	}
	
	func game(isOver: Bool) {
		gameButton.isSelected = isOver
	}
	
	func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
		if case .began =  gestureRecognizer.state {
			AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
		}
		if case .ended = gestureRecognizer.state {
			let p = gestureRecognizer.location(in: self.collectionView)

			if let indexPath = self.collectionView.indexPathForItem(at: p) {
				dataSource?.plantFlag(at: indexPath)
			}
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		guard let size = collectionView?.bounds.size else {
			return
		}
		let w = Int(size.width / 32)
		let h = Int(size.height / 32)
		if let oldSize = self.dataSource?.gameModel.size, w == oldSize.w && h == oldSize.h {
			// Nothing actually changed
			return
		}
		
		loadNewGame()
	}
	
	func loadNewGame() {
		guard let size = collectionView?.bounds.size else {
			return
		}
		let w = Int(size.width / 32)
		let h = Int(size.height / 32)
		let dataSource = BitMinesDataSource(size:GameSize(w: w, h: h))
		dataSource.gameSpaceReloadable = collectionView
		self.dataSource = dataSource
		dataSource.gameModel.gameOverObserver = self
		let delegate = BitMinesDelegate(mineSpaceSelectable: dataSource)
		self.delegate = delegate
		collectionView.dataSource = dataSource
		collectionView.delegate = delegate
	
	}
	
	@IBAction func restartGame(sender: AnyObject) {
		loadNewGame()
	}
}

