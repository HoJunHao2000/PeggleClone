//
//  Utils.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 10/2/24.
//

import Foundation

class Utils {
    static func closestPointOnLine(to point: CGPoint, lineStart: CGPoint, lineEnd: CGPoint) -> CGPoint {
        // Calculate line vector and normalize it to get line normal
        let lineVector = CGVector(dx: lineEnd.x - lineStart.x, dy: lineEnd.y - lineStart.y)
        let lineNormal = Utils.normalize(CGVector(dx: -lineVector.dy, dy: lineVector.dx))

        // Calculate vector from circle center to line start point
        let circleToStart = CGVector(dx: point.x - lineStart.x, dy: point.y - lineStart.y)

        // Calculate distance from circle center to line
        let distanceFromLine = Utils.dotProduct(circleToStart, lineNormal)

        // Calculate projected point on the line
        let projectedPoint = CGPoint(x: point.x - distanceFromLine * lineNormal.dx,
                                     y: point.y - distanceFromLine * lineNormal.dy)

        return projectedPoint
    }

    static func dotProduct(_ v1: CGVector, _ v2: CGVector) -> CGFloat {
        v1.dx * v2.dx + v1.dy * v2.dy
    }

    static func normalize(_ vector: CGVector) -> CGVector {
        let length = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        return CGVector(dx: vector.dx / length, dy: vector.dy / length)
    }

    static func reflect(_ velocity: CGVector, _ normal: CGVector) -> CGVector {
        let dot = dotProduct(velocity, normal)
        return CGVector(dx: velocity.dx - 2 * dot * normal.dx, dy: velocity.dy - 2 * dot * normal.dy)
    }

    static func scaleBy(_ vector: CGVector, n: Double) -> CGVector {
        CGVector(dx: vector.dx * n, dy: vector.dy * n)
    }
}
