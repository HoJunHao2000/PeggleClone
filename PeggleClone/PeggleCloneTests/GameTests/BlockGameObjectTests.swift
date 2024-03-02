//
//  BlockGameObjectTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/3/24.
//

import XCTest
@testable import PeggleClone

final class BlockGameObjectTests: XCTestCase {
    func testInitialization() {
        let block = Block(id: UUID(), position: CGPoint(x: 10, y: 20))
        let blockGameObject = BlockGameObject(block: block)

        XCTAssertNotNil(blockGameObject, "Block game object not initialised.")
    }

    func testPosition() {
        let block = Block(id: UUID(), position: CGPoint(x: 10, y: 20))
        let blockGameObject = BlockGameObject(block: block)

        XCTAssertEqual(blockGameObject.position,
                       CGPoint(x: 10, y: 20),
                       "Position property does not return the correct position")
    }

    func testRotation() {
        let block = Block(id: UUID(), position: CGPoint(x: 10, y: 20), rotation: 90)
        let blockGameObject = BlockGameObject(block: block)

        XCTAssertEqual(blockGameObject.rotation, 90, "Rotation property does not return the correct rotation")
    }

    func testHeight() {
        let block = Block(id: UUID(), position: CGPoint(x: 10, y: 20), size: CGSize(width: 10, height: 20))
        let blockGameObject = BlockGameObject(block: block)

        XCTAssertEqual(blockGameObject.height, 20, "Height property does not return the correct height")
    }

    func testWidth() {
        let block = Block(id: UUID(), position: CGPoint(x: 10, y: 20), size: CGSize(width: 10, height: 20))
        let blockGameObject = BlockGameObject(block: block)

        XCTAssertEqual(blockGameObject.width, 10, "Width property does not return the correct width")
    }
}
