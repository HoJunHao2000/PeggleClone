//
//  IntersectorTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 17/2/24.
//

import XCTest
@testable import PeggleClone

final class IntersectorTests: XCTestCase {
    let intersector = IntersectorDelegate()

    let circle1 = CirclePhysicsObject(position: CGPoint(x: 0, y: 0),
                                      velocity: CGVector(dx: 0, dy: 0),
                                      force: CGVector(dx: 0, dy: 0),
                                      isMoveable: true,
                                      diameter: 2,
                                      elasticity: 1,
                                      rotation: 0)

    let circle2 = CirclePhysicsObject(position: CGPoint(x: 5, y: 5),
                                      velocity: CGVector(dx: 0, dy: 0),
                                      force: CGVector(dx: 0, dy: 0),
                                      isMoveable: true,
                                      diameter: 2,
                                      elasticity: 1,
                                      rotation: 0)

    let circle3 = CirclePhysicsObject(position: CGPoint(x: 0, y: 0),
                                      velocity: CGVector(dx: 0, dy: 0),
                                      force: CGVector(dx: 0, dy: 0),
                                      isMoveable: true,
                                      diameter: 10,
                                      elasticity: 1,
                                      rotation: 0)

    let circle4 = CirclePhysicsObject(position: CGPoint(x: 0, y: 0),
                                      velocity: CGVector(dx: 0, dy: 0),
                                      force: CGVector(dx: 0, dy: 0),
                                      isMoveable: true,
                                      diameter: 5,
                                      elasticity: 1,
                                      rotation: 0)

    let line = LinePhysicsObject(startPoint: CGPoint(x: 0, y: -3), endPoint: CGPoint(x: 0, y: 3))

    func testCircleCircleIntersections() {
        // No intersection
        XCTAssertFalse(intersector.intersects(circle1: circle1, circle2: circle2))

        // Partial intersection
        XCTAssertTrue(intersector.intersects(circle1: circle3, circle2: circle3))

        // One circle inside the other
        XCTAssertTrue(intersector.intersects(circle1: circle3, circle2: circle4))
    }

    func testCircleLineIntersections() {
        XCTAssertTrue(intersector.intersects(circle: circle1, line: line))
    }

    func testCircleRectIntersections() {
        let rect = RectPhysicsObject(position: CGPoint(x: 0, y: 0),
                                     size: CGSize(width: 2, height: 2),
                                     elasticity: 1,
                                     rotation: 0)

        XCTAssertTrue(intersector.intersects(circle: circle1, rect: rect))
    }

    func testRectLineIntersections() {
        let rect = RectPhysicsObject(position: CGPoint(x: 0, y: 0),
                                     size: CGSize(width: 2, height: 2),
                                     elasticity: 1,
                                     rotation: 0,
                                     isMoveable: true)

        XCTAssertTrue(intersector.intersects(rect: rect, line: line))
    }
}
