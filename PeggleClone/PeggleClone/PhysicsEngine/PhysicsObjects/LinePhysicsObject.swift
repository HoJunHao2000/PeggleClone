//
//  LinePhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import Foundation

class LinePhysicsObject: PhysicsObject {
    static let DEFAULT_LINE_ELASTICITY: Double = 0.95

    let startPoint: CGPoint
    let endPoint: CGPoint

    let intersector = IntersectorDelegate()
    let collisionHandler = CollisionDelegate()

    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(position: startPoint,
                   velocity: CGVector(dx: 0, dy: 0),
                   force: CGVector(dx: 0, dy: 0),
                   isMoveable: false,
                   elasticity: LinePhysicsObject.DEFAULT_LINE_ELASTICITY)
    }

    override func intersects(_ physicsObject: PhysicsObject) -> Bool {
        physicsObject.intersectsWithLine(self)
    }

    override func intersectsWithCircle(_ circle: CirclePhysicsObject) -> Bool {
        intersector.intersects(circle: circle, line: self)
    }

    override func intersectsWithRectangle(_ rect: RectPhysicsObject) -> Bool {
        intersector.intersects(rect: rect, line: self)
    }

    override func collides(_ physicsObject: PhysicsObject) {
        physicsObject.collidesWithLine(self)
    }

    override func collidesWithCircle(_ circle: CirclePhysicsObject) {
        collisionHandler.handleCircleLineCollision(circle: circle, line: self)
    }

    override func collidesWithRectangle(_ rect: RectPhysicsObject) {
        collisionHandler.handleRectLineCollision(rect: rect, line: self)
    }
}
