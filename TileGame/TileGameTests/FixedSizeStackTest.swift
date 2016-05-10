//
//  FixedSizeStackTest.swift
//  TileGame
//
//  Created by Andrei Luca on 5/10/16.
//  Copyright © 2016 Tile Game. All rights reserved.
//

import XCTest

class FixedSizeStackTest: XCTestCase {

    let stack: FixedSizeStack<Int> = FixedSizeStack(size: 5)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMaxSize() {
        XCTAssertTrue(stack.maxSize == 5)
    }

    func testItemsCount() {
        XCTAssertTrue(stack.items.count == 0)
    }
    
    func testPopWithoutItems() {
        XCTAssertNil(stack.pop())
    }

    func testPush() {
        stack.push(100)

        XCTAssertTrue(stack.pop() == 100)

        XCTAssertTrue(stack.items.count == 0)
    }

    func testFixedSize() {

        stack.push(5)
        stack.push(6)
        stack.push(7)
        stack.push(8)
        stack.push(9)
        stack.push(10)
        stack.push(11)

        XCTAssertTrue(stack.pop() == 11)
        XCTAssertTrue(stack.pop() == 10)
        XCTAssertTrue(stack.pop() == 9)
        XCTAssertTrue(stack.pop() == 8)
        XCTAssertTrue(stack.pop() == 7)

        XCTAssertFalse(stack.pop() == 6)

        XCTAssertNil(stack.pop())
        XCTAssertNil(stack.pop())
    }

    func testItemsCountAfterTests() {
        XCTAssertTrue(stack.items.count == 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
