//
//  BlockTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/3/24.
//

import XCTest
@testable import PeggleClone

final class BlockTests: XCTestCase {

    func testInit() {
        let id = UUID()
        let position = CGPoint(x: 100, y: 200)
        let size = CGSize(width: 50, height: 25)
        let rotation = 0.0

        let block = Block(id: id, position: position, size: size, rotation: rotation)

        XCTAssertEqual(block.id, id, "Incorrect ID")
        XCTAssertEqual(block.position, position, "Incorrect position")
        XCTAssertEqual(block.size, size, "Incorrect size")
        XCTAssertEqual(block.rotation, rotation, "Incorrect rotation")
    }

    func testSetPosition() {
        let block = Block(id: UUID(), position: CGPoint(x: 100, y: 200))

        let newPosition = CGPoint(x: 300, y: 400)
        block.setPosition(newPosition: newPosition)
        XCTAssertEqual(block.position, newPosition, "Block position should be updated")

        let anotherNewPosition = CGPoint(x: 150, y: 250)
        block.setPosition(newPosition: anotherNewPosition)
        XCTAssertEqual(block.position, anotherNewPosition, "Block position should be updated again")

        block.setPosition(newPosition: anotherNewPosition)
        XCTAssertEqual(block.position,
                       anotherNewPosition,
                       "Setting position to the same position should have no effect")

        let negativePosition = CGPoint(x: -5, y: 40)
        block.setPosition(newPosition: negativePosition)
        XCTAssertEqual(block.position, anotherNewPosition, "Should have no effect due to invalid position input")
    }

    func testSetRotation() {
        let block = Block(id: UUID(), position: CGPoint(x: 100, y: 200))

        block.setRotation(newAngle: 90.0)
        XCTAssertEqual(block.rotation, 90.0, "Failed to set rotation")

        block.setRotation(newAngle: -180.0)
        XCTAssertEqual(block.rotation, -180.0, "Failed to set rotation")
    }

    func testSetHeight() {
        let block = Block(id: UUID(), position: CGPoint(x: 100, y: 200))

        block.setHeight(newHeight: 50)
        XCTAssertEqual(block.height, 50, "Failed to set height")

        block.setHeight(newHeight: -50)
        XCTAssertEqual(block.height, 50, "Failed to set height")
    }

    func testSetWidth() {
        let block = Block(id: UUID(), position: CGPoint(x: 100, y: 200))

        block.setWidth(newWidth: 50)
        XCTAssertEqual(block.width, 50, "Failed to set width")

        block.setWidth(newWidth: -50)
        XCTAssertEqual(block.width, 50, "Failed to set width")
    }

    func testEquality() {
        let block1Id = UUID()
        let block2Id = UUID()
        let position_1 = CGPoint(x: 10, y: 20)
        let position_2 = CGPoint(x: 15, y: 25)

        let block1 = Block(id: block1Id, position: position_1)
        let block2 = Block(id: block1Id, position: position_1)
        let block3 = Block(id: block2Id, position: position_2)
        let block4 = Block(id: block2Id, position: position_1)

        XCTAssertEqual(block1, block2, "Blocks with the same ID should be equal")
        XCTAssertEqual(block3, block4, "Blocks with the same ID but different position should be equal")
        XCTAssertNotEqual(block2, block4, "Blocks with different ID and same position should not be equal")
    }
}
