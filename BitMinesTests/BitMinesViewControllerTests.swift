//
//  BitMinesViewControllerTests.swift
//  BitMines
//
//  Created by Andrew Rahn on 1/21/17.
//  Copyright © 2017 Andrew Rahn. All rights reserved.
//

import XCTest
import UIKit
@testable import BitMines

class BitMinesViewControllerTests: XCTestCase {
	var storyboard: UIStoryboard!
	var sut: BitMinesViewController!

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		storyboard = UIStoryboard(name: "Main", bundle: nil)
		sut = storyboard.instantiateViewController(withIdentifier: "game_board") as? BitMinesViewController
		
		let view = sut.view
		
		view?.bounds = CGRect(x: 0, y: 0, width: 320, height: 480)
		view?.setNeedsLayout()
		view?.layoutIfNeeded()
	}

    func testSanity() {
        XCTAssertNotNil(sut)
    }
	
	func testCollectionView() {
		XCTAssertNotNil(sut.collectionView)
	}
	
	func testUnexploredCell() {
		let key = BitMinesDataSource.kUnexploredCellIdentifier
		let indexPath = IndexPath(row: 0, section: 0)
		let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: key, for: indexPath) as? BitMinesCell
		XCTAssertNotNil(cell)
	}
	
	func testDataSource() {
		XCTAssertNotNil(sut.collectionView.dataSource as? BitMinesDataSource)
	}
	
	func testDelegate() {
		XCTAssertNotNil(sut.collectionView.delegate as? BitMinesDelegate)
	}
	
	func testLongPressNotNil() {
		XCTAssertNotNil(sut.longPressRecognizer)
	}
	
	
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
}
