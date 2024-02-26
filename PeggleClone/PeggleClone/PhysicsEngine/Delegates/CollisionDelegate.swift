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
        } else if let circle = object1 as? CirclePhysicsObject, let block = object2 as? BlockPhysicsObject {
            handleCircleBlockCollision(circle: circle, block: block)
        } else if let block = object1 as? BlockPhysicsObject, let circle = object2 as? CirclePhysicsObject {
            handleCircleBlockCollision(circle: circle, block: block)
        } else {
            return
        }
    }

    private func handleCircleLineCollision(circle: CirclePhysicsObject, line: LinePhysicsObject) {
        guard circle.isMoveable else {
            return
        }

        // Reflect circle velocity and scale it with line elasticity
        let lineVector = CGVector(dx: line.endPoint.x - line.startPoint.x, dy: line.endPoint.y - line.startPoint.y)
        let lineNormal = Utils.normalize(CGVector(dx: -lineVector.dy, dy: lineVector.dx))
        let reflectedVelocity = Utils.reflect(circle.velocity, lineNormal)
        let scaledVelocity = Utils.scaleBy(reflectedVelocity, n: line.elasticity)
        circle.setVelocity(newVelocity: scaledVelocity)

        // Calculate overlap and adjustment vector
        let circleToStart = CGVector(dx: circle.position.x - line.startPoint.x,
                                     dy: circle.position.y - line.startPoint.y)
        let distanceFromLine = Utils.dotProduct(circleToStart, lineNormal)
        let overlap = ((circle.diameter / 2) - distanceFromLine) * 1.001

        guard overlap > 0 else {
            return
        }

        var adjustmentVector: CGVector
        if distanceFromLine >= 0 {
            adjustmentVector = CGVector(dx: lineNormal.dx * overlap, dy: lineNormal.dy * overlap)
        } else {
            adjustmentVector = CGVector(dx: -lineNormal.dx * overlap, dy: -lineNormal.dy * overlap)
        }

        // Adjust circle position to move it outside the line
        circle.setPosition(newPosition: CGPoint(x: circle.position.x + adjustmentVector.dx,
                                                y: circle.position.y + adjustmentVector.dy))
    }

    private func handleCircleCircleCollision(circle1: CirclePhysicsObject, circle2: CirclePhysicsObject) {
        // Calculate the vector from circle1 to circle2
        let dx = circle2.position.x - circle1.position.x
        let dy = circle2.position.y - circle1.position.y

        // Calculate the normal vector
        let normal = CGVector(dx: dx, dy: dy)
        let normalizedNormal = Utils.normalize(normal)

        // Calculate the combined radius and overlap
        let distance = sqrt(dx * dx + dy * dy)
        let combinedRadius = (circle1.diameter / 2) + (circle2.diameter / 2)
        let overlap = (combinedRadius - distance) * 1.001

        guard overlap > 0 else {
            return
        }

        // Calculate the adjustment vector to separate the circles
        let adjustmentVector2 = CGVector(dx: normalizedNormal.dx * overlap, dy: normalizedNormal.dy * overlap)
        let adjustmentVector1 = CGVector(dx: -normalizedNormal.dx * overlap, dy: -normalizedNormal.dy * overlap)

        // Handle collision for circle1
        if circle1.isMoveable && circle1.mass.isFinite {
            // Reflect circle1's velocity
            let reflectedVelocity1 = Utils.reflect(circle1.velocity, normalizedNormal)
            // Scale down the velocity considering circle2's elasticity
            let scaledDownVelocity1 = Utils.scaleBy(reflectedVelocity1, n: circle2.elasticity)
            circle1.setVelocity(newVelocity: scaledDownVelocity1)
            // Increment the hit count of circle1
            circle2.incrementHitCount()
            // Adjust the position of circle1
            circle1.setPosition(newPosition: CGPoint(x: circle1.position.x + adjustmentVector1.dx,
                                                     y: circle1.position.y + adjustmentVector1.dy))
        }

        // Handle collision for circle2
        if circle2.isMoveable && circle2.mass.isFinite {
            // Reflect circle2's velocity
            let reflectedVelocity2 = Utils.reflect(circle2.velocity, normalizedNormal)
            // Scale down the velocity considering circle1's elasticity
            let scaledDownVelocity2 = Utils.scaleBy(reflectedVelocity2, n: circle1.elasticity)
            circle2.setVelocity(newVelocity: scaledDownVelocity2)
            // Increment the hit count of circle2
            circle1.incrementHitCount()
            // Adjust the position of circle2
            circle2.setPosition(newPosition: CGPoint(x: circle2.position.x + adjustmentVector2.dx,
                                                     y: circle2.position.y + adjustmentVector2.dy))
        }
    }

    private func handleCircleBlockCollision(circle: CirclePhysicsObject, block: BlockPhysicsObject) {
        guard circle.isMoveable else {
            return
        }

        let blockCorners = Utils.cornersOfRect(size: block.size, position: block.position, rotation: block.rotation)

        // Find the edge of the block that is closest to the circle
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        var distanceFromLine: Double = CGFloat.greatestFiniteMagnitude
        for i in 0..<4 {
            let corner1 = blockCorners[i]
            let corner2 = blockCorners[(i + 1) % 4]
            let closestPoint = Utils.closestPointOnLine(to: circle.position, lineStart: corner1, lineEnd: corner2)
            let distance = Utils.distanceBetween(point1: closestPoint, point2: circle.position)
            if distance < distanceFromLine {
                startPoint = corner1
                endPoint = corner2
                distanceFromLine = distance
            }
        }

        // Get the normal vector from the closest edge
        let lineVector = CGVector(dx: endPoint.x - startPoint.x, dy: endPoint.y - startPoint.y)
        let lineNormal = Utils.normalize(CGVector(dx: lineVector.dy, dy: -lineVector.dx))
        let reflectedVelocity = Utils.reflect(circle.velocity, lineNormal)
        let isLeft = Utils.isBallOnLeftSide(startpoint: startPoint, endpoint: endPoint, point: circle.position)
        let scaledVelocity = Utils.scaleBy(reflectedVelocity, n: block.elasticity)
        circle.setVelocity(newVelocity: scaledVelocity)

        // Calculate overlap and adjustment vector
        var overlap = ((circle.diameter / 2) - distanceFromLine) * 1.001
        if !isLeft {
            overlap += (circle.diameter / 2)
        }

        let adjustmentVector = CGVector(dx: lineNormal.dx * overlap, dy: lineNormal.dy * overlap)

        // Adjust circle position to move it outside the line
        circle.setPosition(newPosition: CGPoint(x: circle.position.x + adjustmentVector.dx,
                                                y: circle.position.y + adjustmentVector.dy))
    }
}
