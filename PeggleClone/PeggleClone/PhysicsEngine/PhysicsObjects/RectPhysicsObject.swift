//
//  RectPhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 26/2/24.
//

import Foundation

class RectPhysicsObject: PhysicsObject {
    let size: CGSize
    let rotation: Double

    let intersector = IntersectorDelegate()
    let collisionHandler = CollisionDelegate()

    init(position: CGPoint,
         size: CGSize,
         elasticity: Double,
         rotation: Double = 0,
         velocity: CGVector = .zero,
         isMoveable: Bool = false) {
        self.size = size
        self.rotation = rotation
        super.init(position: position,
                   velocity: velocity,
                   force: CGVector(dx: 0, dy: 0),
                   isMoveable: isMoveable,
                   elasticity: elasticity)
    }

    override func intersects(_ physicsObject: PhysicsObject) -> Bool {
        physicsObject.intersectsWithRectangle(self)
    }

    override func intersectsWithCircle(_ circle: CirclePhysicsObject) -> Bool {
        intersector.intersects(circle: circle, rect: self)
    }

    override func intersectsWithLine(_ line: LinePhysicsObject) -> Bool {
        intersector.intersects(rect: self, line: line)
    }

    override func collides(_ physicsObject: PhysicsObject) {
        physicsObject.collidesWithRectangle(self)
    }

    override func collidesWithCircle(_ circle: CirclePhysicsObject) {
        collisionHandler.handleCircleRectCollision(circle: circle, rect: self)
    }

    override func collidesWithLine(_ line: LinePhysicsObject) {
        collisionHandler.handleRectLineCollision(rect: self, line: line)
    }
}
