//
//  PhysicsObjectTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 17/2/24.
//

import XCTest
@testable import PeggleClone

final class PhysicsObjectTests: XCTestCase {
    func testInitialization() {
        // Test with default values
        let defaultPhysicsObject = PhysicsObject(position: .zero,
                                                 velocity: .zero,
                                                 force: .zero,
                                                 isMoveable: true)
        XCTAssertEqual(defaultPhysicsObject.position, .zero, "Default position should be CGPoint.zero")
        XCTAssertEqual(defaultPhysicsObject.velocity, .zero, "Default velocity should be CGVector.zero")
        XCTAssertEqual(defaultPhysicsObject.force, .zero, "Default force should be CGVector.zero")
        XCTAssertEqual(defaultPhysicsObject.hitCount, 0, "Default hit count should be 0")
        XCTAssertTrue(defaultPhysicsObject.isMoveable, "Default isMoveable should be true")
        XCTAssertEqual(defaultPhysicsObject.elasticity, 1, "Default elasticity should be 1")
        XCTAssertEqual(defaultPhysicsObject.mass, Double.infinity, "Default mass should be Double.infinity")

        // Test with default elasticity and custom mass
        let customMass = 2.0
        let physicsObjectDefaultElasticity = PhysicsObject(position: .zero,
                                                           velocity: .zero,
                                                           force: .zero,
                                                           isMoveable: true,
                                                           mass: customMass)
        XCTAssertEqual(physicsObjectDefaultElasticity.elasticity, 1, "Default elasticity should be 1")
        XCTAssertEqual(physicsObjectDefaultElasticity.mass, customMass, "Custom mass should be set")

        // Test with default mass and custom elasticity
        let customElasticity = 0.8
        let physicsObjectDefaultMass = PhysicsObject(position: .zero,
                                                     velocity: .zero,
                                                     force: .zero,
                                                     isMoveable: true,
                                                     elasticity: customElasticity)
        XCTAssertEqual(physicsObjectDefaultMass.elasticity, customElasticity, "Custom elasticity should be set")
        XCTAssertEqual(physicsObjectDefaultMass.mass, Double.infinity, "Default mass should be Double.infinity")

        // Test all fields present
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true,
                                          elasticity: customElasticity,
                                          mass: customMass)
        XCTAssertEqual(physicsObject.elasticity, customElasticity, "Custom elasticity should be set")
        XCTAssertEqual(physicsObject.mass, customMass, "Custom mass should be set")
    }

    func testIsFirstHit() {
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true)

        XCTAssertFalse(physicsObject.isFirstHit, "Hit count should be 0")

        physicsObject.incrementHitCount()
        XCTAssertTrue(physicsObject.isFirstHit, "Hit count should be 1")
    }

    func testIncrementHitCount() {
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true)

        physicsObject.incrementHitCount()
        XCTAssertEqual(physicsObject.hitCount, 1, "Hit count should be incremented to 1")

        physicsObject.incrementHitCount()
        XCTAssertEqual(physicsObject.hitCount, 2, "Hit count should be incremented to 2")
    }

    func testSetHitCount() {
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true)

        physicsObject.setHitCount(newHitCount: 2)
        XCTAssertEqual(physicsObject.hitCount, 2, "Hit count should be set to 2")

        physicsObject.setHitCount(newHitCount: 0)
        XCTAssertEqual(physicsObject.hitCount, 0, "Hit count should be set to 0")
    }

    func testSetVelocity() {
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true)

        let newVelocity = CGVector(dx: 2, dy: 2)
        physicsObject.setVelocity(newVelocity: newVelocity)

        XCTAssertEqual(physicsObject.velocity, newVelocity, "Velocity should be set to the new velocity")
    }

    func testSetPosition() {
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true)

        let newPosition = CGPoint(x: 2, y: 2)
        physicsObject.setPosition(newPosition: newPosition)

        XCTAssertEqual(physicsObject.position, newPosition, "Position should be set to the new position")
    }

    func testResetHitCount() {
        let physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: .zero,
                                          isMoveable: true)

        physicsObject.incrementHitCount()
        XCTAssertEqual(physicsObject.hitCount, 1, "Hit count should be incremented to 1")

        physicsObject.resetHitCount()
        XCTAssertEqual(physicsObject.hitCount, 0, "Hit count should be reset to 0")
    }

    func testUpdate() {
        // Test with a movable object and a force
        var physicsObject = PhysicsObject(position: .zero,
                                          velocity: .zero,
                                          force: CGVector(dx: 1, dy: 1),
                                          isMoveable: true)

        physicsObject.update(timeDelta: 1.0)

        XCTAssertEqual(physicsObject.velocity, CGVector(dx: 1, dy: 1), "Velocity should be updated")
        XCTAssertEqual(physicsObject.position, CGPoint(x: 0.5, y: 0.5), "Position should be updated")

        // Test with a movable object and no force
        physicsObject = PhysicsObject(position: .zero,
                                      velocity: CGVector(dx: 1, dy: 1),
                                      force: .zero,
                                      isMoveable: true)

        physicsObject.update(timeDelta: 1.0)

        XCTAssertEqual(physicsObject.velocity, CGVector(dx: 1, dy: 1), "Velocity should remain the same")
        XCTAssertEqual(physicsObject.position, CGPoint(x: 1, y: 1), "Position should be updated")

        // Test with a non-movable object and a force
        physicsObject = PhysicsObject(position: .zero,
                                      velocity: .zero,
                                      force: CGVector(dx: 1, dy: 1),
                                      isMoveable: false)

        physicsObject.update(timeDelta: 1.0)

        XCTAssertEqual(physicsObject.velocity, CGVector(dx: 0, dy: 0), "Velocity should remain zero")
        XCTAssertEqual(physicsObject.position, .zero, "Position should remain at zero")

        // Test with a time delta of 0
        physicsObject = PhysicsObject(position: .zero,
                                      velocity: .zero,
                                      force: CGVector(dx: 1, dy: 1),
                                      isMoveable: true)

        physicsObject.update(timeDelta: 0.0)

        XCTAssertEqual(physicsObject.velocity, CGVector(dx: 0, dy: 0), "Velocity should remain zero")
        XCTAssertEqual(physicsObject.position, .zero, "Position should remain at zero")

        // Test with a negative force
        physicsObject = PhysicsObject(position: .zero,
                                      velocity: .zero,
                                      force: CGVector(dx: -1, dy: -1),
                                      isMoveable: true)

        physicsObject.update(timeDelta: 1.0)

        XCTAssertEqual(physicsObject.velocity, CGVector(dx: -1, dy: -1), "Velocity should be updated")
        XCTAssertEqual(physicsObject.position, CGPoint(x: -0.5, y: -0.5), "Position should be updated")

        // Test with a negative time delta
        physicsObject = PhysicsObject(position: .zero,
                                      velocity: .zero,
                                      force: CGVector(dx: 1, dy: 1),
                                      isMoveable: true)

        physicsObject.update(timeDelta: -1.0)

        XCTAssertEqual(physicsObject.velocity, CGVector(dx: 0, dy: 0), "Velocity should remain zero")
        XCTAssertEqual(physicsObject.position, .zero, "Position should remain at zero")
    }

    func testHashableConformance() {
        let physicsObject1 = PhysicsObject(position: .zero,
                                           velocity: .zero,
                                           force: .zero,
                                           isMoveable: true)

        let physicsObject2 = PhysicsObject(position: .zero,
                                           velocity: .zero,
                                           force: .zero,
                                           isMoveable: true)

        let physicsObject3 = PhysicsObject(position: .zero,
                                           velocity: .zero,
                                           force: .zero,
                                           isMoveable: false)

        XCTAssertEqual(physicsObject1.hashValue,
                       physicsObject1.hashValue,
                       "Hash value should be consistent for the same object")
        XCTAssertEqual(physicsObject1, physicsObject1, "Same objects should be equal")
        XCTAssertNotEqual(physicsObject1.hashValue,
                          physicsObject2.hashValue,
                          "Hash value should be different for different object")
        XCTAssertNotEqual(physicsObject1, physicsObject2, "Objects with the same properties should not be equal")

        XCTAssertNotEqual(physicsObject1, physicsObject3, "Objects with different properties should not be equal")
        XCTAssertNotEqual(physicsObject1.hashValue,
                          physicsObject3.hashValue,
                          "Objects with different properties should have different hash values")
    }
}
