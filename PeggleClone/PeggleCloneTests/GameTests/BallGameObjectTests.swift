//
//  BallGameObjectTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 17/2/24.
//

import XCTest
@testable import PeggleClone

final class BallGameObjectTests: XCTestCase {
    // Test if the physics object of a newly created ball is initialized correctly
    func testPhysicsObjectInitialization() {
        let initialPosition = CGPoint(x: 0, y: 0)
        let initialForce = CGVector(dx: 0, dy: 0)
        let initialVelocity = CGVector(dx: 0, dy: 0)

        let ball = BallGameObject(initialPosition: initialPosition,
                                  initialForce: initialForce,
                                  initialVelocity: initialVelocity)

        XCTAssertEqual(ball.physicsObject.position, initialPosition, "Position is not initialized correctly")
        XCTAssertEqual(ball.physicsObject.velocity, initialVelocity, "Velocity is not initialized correctly")
        XCTAssertEqual(ball.physicsObject.force, initialForce, "Force is not initialized correctly")
        XCTAssertTrue(ball.physicsObject.isMoveable, "isMoveable is not initialized correctly")
        XCTAssertEqual(ball.physicsObject.diameter,
                       BallGameObject.DEFAULT_BALL_DIAMETER,
                       "Diameter is not initialized correctly")
        XCTAssertEqual(ball.physicsObject.mass, 50, "Mass is not initialized correctly")
        XCTAssertEqual(ball.physicsObject.elasticity, 1, "Elasticity is not initialized correctly")
    }

    // Test if the position property returns the correct position of the ball
    func testPosition() {
        let initialPosition = CGPoint(x: 10, y: 20)
        let initialForce = CGVector(dx: 0, dy: 0)
        let initialVelocity = CGVector(dx: 0, dy: 0)

        let ball = BallGameObject(initialPosition: initialPosition,
                                  initialForce: initialForce,
                                  initialVelocity: initialVelocity)

        XCTAssertEqual(ball.position, initialPosition, "Position property does not return the correct position")
    }

    // Test if the diameter property returns the correct diameter of the ball
    func testDiameter() {
        let initialPosition = CGPoint(x: 0, y: 0)
        let initialForce = CGVector(dx: 0, dy: 0)
        let initialVelocity = CGVector(dx: 0, dy: 0)

        let ball = BallGameObject(initialPosition: initialPosition,
                                  initialForce: initialForce,
                                  initialVelocity: initialVelocity)

        XCTAssertEqual(ball.diameter,
                       BallGameObject.DEFAULT_BALL_DIAMETER,
                       "Diameter property does not return the correct diameter")
    }
}
