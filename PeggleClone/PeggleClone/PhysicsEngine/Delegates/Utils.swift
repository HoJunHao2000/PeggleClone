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

        // Clamp the projected point to the line segment
        let clampedPoint = CGPoint(x: max(min(projectedPoint.x, max(lineStart.x, lineEnd.x)),
                                          min(lineStart.x, lineEnd.x)),
                                    y: max(min(projectedPoint.y, max(lineStart.y, lineEnd.y)),
                                           min(lineStart.y, lineEnd.y)))

        return clampedPoint
    }

    static func dotProduct(_ v1: CGVector, _ v2: CGVector) -> CGFloat {
        v1.dx * v2.dx + v1.dy * v2.dy
    }

    static func isBallOnLeftSide(startpoint: CGPoint, endpoint: CGPoint, point: CGPoint) -> Bool {
        let cross_prod = (endpoint.x - startpoint.x) * (point.y - startpoint.y)
        - (endpoint.y - startpoint.y) * (point.x - startpoint.x)

        return cross_prod < 0
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

    static func cornersOfRect(size: CGSize, position: CGPoint, rotation: Double = 0) -> [CGPoint] {
        let height = size.height
        let width = size.width
        let halfWidth = width / 2
        let halfHeight = height / 2

        let vertices = [
            CGPoint(x: -halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: halfHeight),
            CGPoint(x: -halfWidth, y: halfHeight)
        ]

        // Rotation matrix
        let angleInRadians = rotation * (.pi / 180.0)
        let cosAngle = cos(angleInRadians)
        let sinAngle = sin(angleInRadians)

        // Translate to center point and rotate
        let rotatedVertices = vertices.map { vertex in
            let x = position.x + vertex.x * cosAngle - vertex.y * sinAngle
            let y = position.y + vertex.x * sinAngle + vertex.y * cosAngle
            return CGPoint(x: x, y: y)
        }

        return rotatedVertices
    }

    static func areaOfTriangle(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGFloat {
        let area = 0.5 * abs((p1.x * (p2.y - p3.y)) + (p2.x * (p3.y - p1.y)) + (p3.x * (p1.y - p2.y)))
        return area
    }

    static func distanceBetween(point1: CGPoint, point2: CGPoint) -> Double {
        sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }

    static func doLinesIntersect(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> Bool {
        let p0_x = start1.x
        let p0_y = start1.y
        let p1_x = end1.x
        let p1_y = end1.y

        let p2_x = start2.x
        let p2_y = start2.y
        let p3_x = end2.x
        let p3_y = end2.y

        let s1_x = p1_x - p0_x
        let s1_y = p1_y - p0_y
        let s2_x = p3_x - p2_x
        let s2_y = p3_y - p2_y

        let s =
            (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y)
        let t =
            (s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y)

        return s >= 0 && s <= 1 && t >= 0 && t <= 1
    }
}
