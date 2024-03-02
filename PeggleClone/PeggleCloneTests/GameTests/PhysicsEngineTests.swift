//
//  PhysicsEngineTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 17/2/24.
//

import XCTest
@testable import PeggleClone

final class PhysicsEngineTests: XCTestCase {
    func testAddPhysicsObject() {
        let physicsEngine = PhysicsEngine()

        // Test adding a valid physics object
        let physicsObject1 = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: true)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject1)
        XCTAssertEqual(physicsEngine.physicsObjects.count, 1, "Physics object should be added")

        // Test adding the same object again (should not add duplicates)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject1)
        XCTAssertEqual(physicsEngine.physicsObjects.count, 1, "Duplicate physics object should not be added")

        // Test adding a different physics object
        let physicsObject2 = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: false)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject2)
        XCTAssertEqual(physicsEngine.physicsObjects.count, 2, "Different physics object should be added")
    }

    func testRemovePhysicsObject() {
        let physicsEngine = PhysicsEngine()
        let physicsObject1 = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: true)
        let physicsObject2 = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: false)

        // Test removing an object that exists
        physicsEngine.addPhysicsObject(physicsObject: physicsObject1)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject2)
        XCTAssertEqual(physicsEngine.physicsObjects.count, 2, "Two physics objects added")

        physicsEngine.removePhysicsObject(physicsObject: physicsObject1)
        XCTAssertEqual(physicsEngine.physicsObjects.count, 1, "Physics object should be removed")

        // Test removing an object that doesn't exist
        physicsEngine.removePhysicsObject(physicsObject: physicsObject1)
        XCTAssertEqual(physicsEngine.physicsObjects.count,
                       1,
                       "Removing non-existent physics object should not change count")

        // Test removing multiple objects
        physicsEngine.addPhysicsObject(physicsObject: physicsObject1)
        physicsEngine.removePhysicsObject(physicsObject: physicsObject2)
        physicsEngine.removePhysicsObject(physicsObject: physicsObject1)
        XCTAssertEqual(physicsEngine.physicsObjects.count, 0, "Physics object should be removed")
    }

    func testUpdatePhysicsObjects() {
        let physicsEngine = PhysicsEngine()
        let physicsObject1 = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: true)
        let physicsObject2 = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: true)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject1)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject2)

        // Test with timeDelta less than or equal to 0
        physicsObject1.setVelocity(newVelocity: CGVector(dx: 1, dy: 1))
        physicsObject2.setVelocity(newVelocity: CGVector(dx: -1, dy: -1))
        physicsEngine.updatePhysicsObjects(timeDelta: 0)
        XCTAssertEqual(physicsObject1.position,
                       .zero,
                       "Physics object 1 position should not change with time delta <= 0")
        XCTAssertEqual(physicsObject2.position,
                       .zero,
                       "Physics object 2 position should not change with time delta <= 0")

        // Test with no physics objects
        physicsEngine.removePhysicsObject(physicsObject: physicsObject1)
        physicsEngine.removePhysicsObject(physicsObject: physicsObject2)
        physicsEngine.updatePhysicsObjects(timeDelta: 1.0) // Should not crash

        // Test with non-movable object
        let nonMovablePhysicsObject = PhysicsObject(position: .zero, velocity: .zero, force: .zero, isMoveable: false)
        physicsEngine.addPhysicsObject(physicsObject: nonMovablePhysicsObject)
        nonMovablePhysicsObject.setVelocity(newVelocity: CGVector(dx: 1, dy: 1))
        physicsEngine.updatePhysicsObjects(timeDelta: 1.0)
        XCTAssertEqual(nonMovablePhysicsObject.position, .zero, "Non-movable physics object position should not change")

        // Test with movable objects and valid time delta
        let physicsObject3 = PhysicsObject(position: .zero,
                                           velocity: .zero,
                                           force: CGVector(dx: 1, dy: 1),
                                           isMoveable: true)
        let physicsObject4 = PhysicsObject(position: .zero,
                                           velocity: .zero,
                                           force: CGVector(dx: -1, dy: -1),
                                           isMoveable: true)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject3)
        physicsEngine.addPhysicsObject(physicsObject: physicsObject4)
        physicsObject3.setVelocity(newVelocity: CGVector(dx: 1, dy: 1))
        physicsObject4.setVelocity(newVelocity: CGVector(dx: -1, dy: -1))
        physicsEngine.updatePhysicsObjects(timeDelta: 1.0)
        XCTAssertEqual(physicsObject3.position,
                       CGPoint(x: 1.5, y: 1.5),
                       "Physics object 1 position should be updated")
        XCTAssertEqual(physicsObject4.position,
                       CGPoint(x: -1.5, y: -1.5),
                       "Physics object 2 position should be updated")
    }
}
