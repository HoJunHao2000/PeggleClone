//
//  CollisionHandlerTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/3/24.
//

import XCTest
@testable import PeggleClone

class CollisionHandlerTests: XCTestCase {
    let collisionHandler = CollisionDelegate()
    let intersector = IntersectorDelegate()

    let circle1 = CirclePhysicsObject(
        position: CGPoint(x: 100, y: 100),
        velocity: CGVector(dx: 0, dy: 0),
        force: CGVector(dx: 0, dy: 0),
        isMoveable: true,
        diameter: 50,
        elasticity: 1,
        rotation: 0
    )

    let circle2 = CirclePhysicsObject(
        position: CGPoint(x: 120, y: 100),
        velocity: CGVector(dx: 0, dy: 0),
        force: CGVector(dx: 0, dy: 0),
        isMoveable: true,
        diameter: 50,
        elasticity: 1,
        rotation: 0
    )

    let circle5 = CirclePhysicsObject(
        position: CGPoint(x: 250, y: 100),
        velocity: CGVector(dx: 0, dy: 0),
        force: CGVector(dx: 0, dy: 0),
        isMoveable: true,
        diameter: 50,
        elasticity: 1,
        rotation: 0
    )

    let circle6 = CirclePhysicsObject(
        position: CGPoint(x: 280, y: 100),
        velocity: CGVector(dx: 0, dy: 0),
        force: CGVector(dx: 0, dy: 0),
        isMoveable: false,
        diameter: 50,
        elasticity: 1,
        rotation: 0
    )

    let circle7 = CirclePhysicsObject(
        position: CGPoint(x: 280, y: 150),
        velocity: CGVector(dx: 0, dy: 0),
        force: CGVector(dx: 0, dy: 0),
        isMoveable: true,
        diameter: 50,
        elasticity: 1,
        rotation: 0
    )

    let circle9 = CirclePhysicsObject(
        position: CGPoint(x: 150, y: 150),
        velocity: CGVector(dx: 0, dy: 0),
        force: CGVector(dx: 0, dy: 0),
        isMoveable: true,
        diameter: 50,
        elasticity: 1,
        rotation: 0
    )

    let rect1 = RectPhysicsObject(
        position: CGPoint(x: 100, y: 100),
        size: CGSize(width: 100, height: 100),
        elasticity: 1
    )

    let line1 = LinePhysicsObject(
        startPoint: CGPoint(x: 300, y: 0),
        endPoint: CGPoint(x: 300, y: 300)
    )

    func testCircleCircleCollision() {
        // Circle-circle collision
        XCTAssertTrue(intersector.intersects(circle1: circle1, circle2: circle2))
        collisionHandler.handleCircleCircleCollision(circle1: circle1, circle2: circle2)
        XCTAssertFalse(intersector.intersects(circle1: circle1, circle2: circle2))

        // Circle-circle collision with immovable circle
        XCTAssertTrue(intersector.intersects(circle1: circle5, circle2: circle6))
        collisionHandler.handleCircleCircleCollision(circle1: circle5, circle2: circle6)
        XCTAssertFalse(intersector.intersects(circle1: circle5, circle2: circle6))
    }

    func testCircleLineCollision() {
        // Circle-line collision
        XCTAssertTrue(intersector.intersects(circle: circle7, line: line1))
        collisionHandler.handleCircleLineCollision(circle: circle7, line: line1)
        XCTAssertFalse(intersector.intersects(circle: circle7, line: line1))
    }

    func testCircleRectCollision() {
        // Circle-rect collision
        XCTAssertTrue(intersector.intersects(circle: circle9, rect: rect1))
        collisionHandler.handleCircleRectCollision(circle: circle9, rect: rect1)
        XCTAssertFalse(intersector.intersects(circle: circle9, rect: rect1))
    }
}
