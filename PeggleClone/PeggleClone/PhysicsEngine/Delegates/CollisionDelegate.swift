//
//  CollisionDelegate.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 10/2/24.
//

import Foundation

class CollisionDelegate {
    func handleCollision(object1: PhysicsObject, object2: PhysicsObject) {
        if let circleObj1 = object1 as? CirclePhysicsObject, let circleObj2 = object2 as? CirclePhysicsObject {
            handleCircleCircleCollision(circle1: circleObj1, circle2: circleObj2)
        } else if let circle = object1 as? CirclePhysicsObject, let line = object2 as? LinePhysicsObject {
            handleCircleLineCollision(circle: circle, line: line)
        } else if let line = object1 as? LinePhysicsObject, let circle = object2 as? CirclePhysicsObject {
            handleCircleLineCollision(circle: circle, line: line)
        } else if let circle = object1 as? CirclePhysicsObject, let rect = object2 as? RectPhysicsObject {
            handleCircleRectCollision(circle: circle, rect: rect)
        } else if let rect = object1 as? RectPhysicsObject, let circle = object2 as? CirclePhysicsObject {
            handleCircleRectCollision(circle: circle, rect: rect)
        } else if let rect = object1 as? RectPhysicsObject, let line = object2 as? LinePhysicsObject {
            handleRectLineCollision(rect: rect, line: line)
        } else {
            return
        }
    }

    private func handleCircleLineCollision(circle: CirclePhysicsObject, line: LinePhysicsObject) {
        guard circle.isMoveable else {
            return
        }

        // Velocity after collision
        let lineVector = Utils.vectorBetweenTwoPoints(line.endPoint, line.startPoint)
        let lineNormal = Utils.normalize(CGVector(dx: -lineVector.dy, dy: lineVector.dx))
        let reflectedVelocity = Utils.reflect(circle.velocity, lineNormal)
        let scaledVelocity = Utils.scaleBy(reflectedVelocity, n: line.elasticity)
        circle.setVelocity(newVelocity: scaledVelocity)

        // Overlap resolution
        let closestPoint = Utils.closestPointOnLine(to: circle.position,
                                                    lineStart: line.startPoint,
                                                    lineEnd: line.endPoint)
        let distanceFromLine = Utils.distanceBetween(point1: closestPoint, point2: circle.position)
        let overlap = ((circle.diameter / 2) - distanceFromLine) * 1.001
        let adjustmentVector = Utils.scaleBy(lineNormal, n: overlap)
        let newPosition = Utils.addVectorToPosition(point: circle.position, vector: adjustmentVector)
        circle.setPosition(newPosition: newPosition)
    }

    private func handleCircleCircleCollision(circle1: CirclePhysicsObject, circle2: CirclePhysicsObject) {
        let normal = Utils.vectorBetweenTwoPoints(circle2.position, circle1.position)
        let normalizedNormal = Utils.normalize(normal)

        let distance = Utils.distanceBetween(point1: circle1.position, point2: circle2.position)
        let overlap = (circle1.diameter / 2) + (circle2.diameter / 2) - distance
        if circle1.isMoveable && circle2.isMoveable {
            // Overlap resolution
            let pen_res_unit = Utils.scaleBy(normalizedNormal, n: -1)
            let pen_res = Utils.scaleBy(pen_res_unit, n: overlap / 2)
            let newPosition1 = Utils.addVectorToPosition(point: circle1.position, vector: pen_res)
            let newPosition2 = Utils.minusVectorFromPosition(point: circle2.position, vector: pen_res)
            circle1.setPosition(newPosition: newPosition1)
            circle2.setPosition(newPosition: newPosition2)

            // Velocity after collision
            let relativeVelocity = Utils.minusVectors(circle1.velocity, circle2.velocity)
            let separatingVelocity = Utils.dotProduct(relativeVelocity, normalizedNormal)
            let newSeparatingVelocity = -separatingVelocity * min(circle1.elasticity, circle2.elasticity)
            let sepVelocitydiff = newSeparatingVelocity - separatingVelocity
            let impluse = sepVelocitydiff / ((1 / circle1.mass) + (1 / circle2.mass))
            let impulseVector = Utils.scaleBy(normalizedNormal, n: impluse)
            let newVelocity1 = Utils.addVectors(circle1.velocity, Utils.scaleBy(impulseVector, n: (1 / circle1.mass)))
            let newVelocity2 = Utils.addVectors(circle2.velocity, Utils.scaleBy(impulseVector, n: -(1 / circle2.mass)))

            circle1.setVelocity(newVelocity: newVelocity1)
            circle2.setVelocity(newVelocity: newVelocity2)
        } else if circle1.isMoveable {
            // Overlap resolution
            let adjustmentVector = Utils.scaleBy(normalizedNormal, n: -overlap)
            let newPosition = Utils.addVectorToPosition(point: circle1.position, vector: adjustmentVector)
            circle1.setPosition(newPosition: newPosition)

            // Velocity after collision
            let reflectedVelocity = Utils.reflect(circle1.velocity, normalizedNormal)
            let scaledDownVelocity = Utils.scaleBy(reflectedVelocity, n: circle2.elasticity)
            circle1.setVelocity(newVelocity: scaledDownVelocity)
            if circle1.diameter == BallGameObject.DEFAULT_BALL_DIAMETER {
                circle2.incrementHitCount()
            }
        } else if circle2.isMoveable {
            // Overlap resolution
            let adjustmentVector = Utils.scaleBy(normalizedNormal, n: overlap)
            let newPosition = Utils.addVectorToPosition(point: circle2.position, vector: adjustmentVector)
            circle2.setPosition(newPosition: newPosition)

            // Velocity after collision
            let reflectedVelocity = Utils.reflect(circle2.velocity, normalizedNormal)
            let scaledDownVelocity = Utils.scaleBy(reflectedVelocity, n: circle1.elasticity)
            circle2.setVelocity(newVelocity: scaledDownVelocity)
            if circle2.diameter == BallGameObject.DEFAULT_BALL_DIAMETER {
                circle1.incrementHitCount()
            }
        }
    }

    private func handleCircleRectCollision(circle: CirclePhysicsObject, rect: RectPhysicsObject) {
        guard circle.isMoveable else {
            return
        }

        let rectCorners = Utils.cornersOfRect(size: rect.size, position: rect.position, rotation: rect.rotation)

        // Find the edge of the block that is closest to the circle
        var edgeNum = 0
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        var distanceFromLine: Double = CGFloat.greatestFiniteMagnitude
        for i in 0..<4 {
            let corner1 = rectCorners[i]
            let corner2 = rectCorners[(i + 1) % 4]
            let closestPoint = Utils.closestPointOnLine(to: circle.position, lineStart: corner1, lineEnd: corner2)
            let distance = Utils.distanceBetween(point1: closestPoint, point2: circle.position)
            if distance < distanceFromLine {
                edgeNum = i
                startPoint = corner1
                endPoint = corner2
                distanceFromLine = distance
            }
        }

        // if edge 0 and rect isMoveable, increment hit count
        if (edgeNum == 0 || edgeNum == 2)
            && rect.isMoveable
            && circle.diameter == BallGameObject.DEFAULT_BALL_DIAMETER {
            rect.incrementHitCount()
            return
        }

        // Velocity after collision
        let lineVector = Utils.vectorBetweenTwoPoints(endPoint, startPoint)
        let lineNormal = Utils.normalize(CGVector(dx: lineVector.dy, dy: -lineVector.dx))
        let reflectedVelocity = Utils.reflect(circle.velocity, lineNormal)
        let scaledVelocity = Utils.scaleBy(reflectedVelocity, n: rect.elasticity)
        circle.setVelocity(newVelocity: scaledVelocity)

        // Overlap resolution
        var overlap = ((circle.diameter / 2) - distanceFromLine) * 1.001
        let isLeft = Utils.isBallOnLeftSide(startpoint: startPoint, endpoint: endPoint, point: circle.position)
        if !isLeft {
            overlap += (circle.diameter / 2)
        }
        let adjustmentVector = Utils.scaleBy(lineNormal, n: overlap)
        let newPosition = Utils.addVectorToPosition(point: circle.position, vector: adjustmentVector)
        circle.setPosition(newPosition: newPosition)
    }

    private func handleRectLineCollision(rect: RectPhysicsObject, line: LinePhysicsObject) {
        // Reverse velocity
        let oldVelocity = rect.velocity
        rect.setVelocity(newVelocity: CGVector(dx: -oldVelocity.dx, dy: oldVelocity.dy))
    }
}
