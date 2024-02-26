import Foundation

class IntersectorDelegate {
    func intersects<T: PhysicsObject, U: PhysicsObject>(object1: T, object2: U) -> Bool {
        if let circle1 = object1 as? CirclePhysicsObject, let circle2 = object2 as? CirclePhysicsObject {
            return intersects(circle1: circle1, circle2: circle2)
        } else if let circle = object1 as? CirclePhysicsObject, let line = object2 as? LinePhysicsObject {
            return intersects(circle: circle, line: line)
        } else if let line = object1 as? LinePhysicsObject, let circle = object2 as? CirclePhysicsObject {
            return intersects(circle: circle, line: line)
        } else if let circle = object1 as? CirclePhysicsObject, let block = object2 as? BlockPhysicsObject {
            return intersects(circle: circle, block: block)
        } else if let block = object1 as? BlockPhysicsObject, let circle = object2 as? CirclePhysicsObject {
            return intersects(circle: circle, block: block)
        } else {
            return false
        }
    }

    private func intersects(circle1: CirclePhysicsObject, circle2: CirclePhysicsObject) -> Bool {
        let radiusSum = (circle1.diameter / 2) + (circle2.diameter / 2)
        let distance = Utils.distanceBetween(point1: circle1.position, point2: circle2.position)
        return distance <= radiusSum
    }

    private func intersects(circle: CirclePhysicsObject, line: LinePhysicsObject) -> Bool {
        let closestPoint = Utils.closestPointOnLine(to: circle.position,
                                                    lineStart: line.startPoint,
                                                    lineEnd: line.endPoint)
        let distance = Utils.distanceBetween(point1: circle.position, point2: closestPoint)
        return distance <= (circle.diameter / 2)
    }

    private func intersects(circle: CirclePhysicsObject, block: BlockPhysicsObject) -> Bool {
        let blockCorners = Utils.cornersOfRect(size: block.size,
                                               position: block.position,
                                               rotation: block.rotation)
        let blockArea = block.size.height * block.size.width
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
}
