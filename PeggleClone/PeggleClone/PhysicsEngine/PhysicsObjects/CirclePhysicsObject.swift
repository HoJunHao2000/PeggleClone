//
//  CirclePhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import Foundation

class CirclePhysicsObject: PhysicsObject {
    let diameter: Double
    let rotation: Double

    let intersector = IntersectorDelegate()
    let collisionHandler = CollisionDelegate()

    init(position: CGPoint,
         velocity: CGVector,
         force: CGVector,
         isMoveable: Bool,
         diameter: Double,
         elasticity: Double,
         rotation: Double,
         mass: Double = PhysicsObject.DEFAULT_MASS) {
        self.diameter = diameter
        self.rotation = rotation
        super.init(position: position,
                   velocity: velocity,
                   force: force,
                   isMoveable: isMoveable,
                   elasticity: elasticity,
                   mass: mass)
    }

    override func intersects(_ physicsObject: PhysicsObject) -> Bool {
        physicsObject.intersectsWithCircle(self)
    }

    override func intersectsWithCircle(_ circle: CirclePhysicsObject) -> Bool {
        intersector.intersects(circle1: self, circle2: circle)
    }

    override func intersectsWithLine(_ line: LinePhysicsObject) -> Bool {
        intersector.intersects(circle: self, line: line)
    }

    override func intersectsWithRectangle(_ rect: RectPhysicsObject) -> Bool {
        intersector.intersects(circle: self, rect: rect)
    }

    override func collides(_ physicsObject: PhysicsObject) {
        physicsObject.collidesWithCircle(self)
    }

    override func collidesWithCircle(_ circle: CirclePhysicsObject) {
        SoundManager.instance.playSound(.hitpeg)
        collisionHandler.handleCircleCircleCollision(circle1: self, circle2: circle)
    }

    override func collidesWithLine(_ line: LinePhysicsObject) {
        SoundManager.instance.playSound(.hitwall)
        collisionHandler.handleCircleLineCollision(circle: self, line: line)
    }

    override func collidesWithRectangle(_ rect: RectPhysicsObject) {
        SoundManager.instance.playSound(.hitblock)
        collisionHandler.handleCircleRectCollision(circle: self, rect: rect)
    }
}
