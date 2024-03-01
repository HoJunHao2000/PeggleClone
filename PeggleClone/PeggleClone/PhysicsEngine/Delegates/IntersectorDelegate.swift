import Foundation

class IntersectorDelegate {
    func intersects(circle1: CirclePhysicsObject, circle2: CirclePhysicsObject) -> Bool {
        let radiusSum = (circle1.diameter / 2) + (circle2.diameter / 2)
        let distance = Utils.distanceBetween(point1: circle1.position, point2: circle2.position)
        return distance <= radiusSum
    }

    func intersects(circle: CirclePhysicsObject, line: LinePhysicsObject) -> Bool {
        let closestPoint = Utils.closestPointOnLine(to: circle.position,
                                                    lineStart: line.startPoint,
                                                    lineEnd: line.endPoint)
        let distance = Utils.distanceBetween(point1: circle.position, point2: closestPoint)
        return distance <= (circle.diameter / 2)
    }

    func intersects(circle: CirclePhysicsObject, rect: RectPhysicsObject) -> Bool {
        let blockCorners = Utils.cornersOfRect(size: rect.size,
                                               position: rect.position,
                                               rotation: rect.rotation)
        let blockArea = rect.size.height * rect.size.width
        let circlePosition = circle.position
        let circleRadius = circle.diameter / 2

        // Check if circle's centre is within block
        let corner1 = blockCorners[0]
        let corner2 = blockCorners[1]
        let corner3 = blockCorners[2]
        let corner4 = blockCorners[3]

        let triangle1 = Utils.areaOfTriangle(p1: corner1, p2: circlePosition, p3: corner4)
        let triangle2 = Utils.areaOfTriangle(p1: corner4, p2: circlePosition, p3: corner3)
        let triangle3 = Utils.areaOfTriangle(p1: corner3, p2: circlePosition, p3: corner2)
        let triangle4 = Utils.areaOfTriangle(p1: corner1, p2: circlePosition, p3: corner2)

        if triangle1 + triangle2 + triangle3 + triangle4 <= blockArea {
            return true
        }

        // Check if any of block edges intersect the circle
        for i in 0..<4 {
            let j = (i + 1) % 4
            let closestPoint = Utils.closestPointOnLine(to: circlePosition,
                                                        lineStart: blockCorners[i],
                                                        lineEnd: blockCorners[j])
            let distance = Utils.distanceBetween(point1: circlePosition, point2: closestPoint)

            if distance <= circleRadius {
                return true
            }
        }

        return false
    }

    func intersects(rect: RectPhysicsObject, line: LinePhysicsObject) -> Bool {
        guard rect.isMoveable else {
            return false
        }

        let corners = Utils.cornersOfRect(size: rect.size, position: rect.position, rotation: rect.rotation)

        return Utils.doLinesIntersect(start1: corners[0],
                                      end1: corners[1],
                                      start2: line.startPoint,
                                      end2: line.endPoint)
    }
}
