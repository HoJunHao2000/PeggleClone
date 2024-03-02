//
//  BucketGameObjectTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/3/24.
//

import XCTest
@testable import PeggleClone

final class BucketGameObjectTests: XCTestCase {
    func testInitialization() {
        let boardSize = CGSize(width: 400, height: 400)
        let bucket = BucketGameObject(boardSize: boardSize)

        XCTAssertNotNil(bucket, "Bucket game object not initialised.")
    }

    func testPosition() {
        let boardSize = CGSize(width: 400, height: 400)
        let bucket = BucketGameObject(boardSize: boardSize)
        let position = CGPoint(x: 50, y: boardSize.height - 50)

        XCTAssertEqual(bucket.position, position, "Position property does not return the correct position")
    }

    func testHeight() {
        let boardSize = CGSize(width: 400, height: 400)
        let bucket = BucketGameObject(boardSize: boardSize)

        XCTAssertEqual(bucket.height,
                       BucketGameObject.DEFAULT_BUCKET_HEIGHT,
                       "Height property does not return the correct height")
    }

    func testWidth() {
        let boardSize = CGSize(width: 400, height: 400)
        let bucket = BucketGameObject(boardSize: boardSize)

        XCTAssertEqual(bucket.width,
                       BucketGameObject.DEFAULT_BUCKET_WIDTH,
                       "Width property does not return the correct width")
    }

    func testElasticity() {
        let boardSize = CGSize(width: 400, height: 400)
        let bucket = BucketGameObject(boardSize: boardSize)

        XCTAssertEqual(bucket.physicsObject.elasticity,
                       BucketGameObject.DEFAULT_BUCKET_ELASTICITY,
                       "Elasticity property does not return the correct elasticity")
    }

    func testIsBallEnter() {
        let boardSize = CGSize(width: 400, height: 400)
        let bucket = BucketGameObject(boardSize: boardSize)

        XCTAssertFalse(bucket.isBallEnter, "isBallEnter property does not return the correct value")

        bucket.physicsObject.incrementHitCount()
        XCTAssertTrue(bucket.isBallEnter, "isBallEnter property does not return the correct value")
    }
}
