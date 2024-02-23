import Foundation

class IntersectorDelegate {
    func intersects<T: PhysicsObject, U: PhysicsObject>(object1: T, object2: U) -> Bool {
        if let circle1 = object1 as? CirclePhysicsObject, let circle2 = object2 as? CirclePhysicsObject {
            return intersects(circle1: circle1, circle2: circle2)
        } else if let circle = object1 as? CirclePhysicsObject, let line = object2 as? LinePhysicsObject {
            return intersects(circle: circle, line: line)
        } else if let line = object1 as? LinePhysicsObject, let circle = object2 as? CirclePhysicsObject {
            return intersects(circle: circle, line: line)
        } else {
            return false
        }
    }

    private func intersects(circle1: CirclePhysicsObject, circle2: CirclePhysicsObject) -> Bool {
        let radiusSum = (circle1.diameter / 2) + (circle2.diameter / 2)
        let distance = hypot(circle1.position.x - circle2.position.x, circle1.position.y - circle2.position.y)
        return distance <= radiusSum
    }

    private func intersects(circle: CirclePhysicsObject, line: LinePhysicsObject) -> Bool {
        let closestPoint = Utils.closestPointOnLine(to: circle.position,
                                                    lineStart: line.startPoint,
                                                    lineEnd: line.endPoint)
        let distance = hypot(circle.position.x - closestPoint.x, circle.position.y - closestPoint.y)
        return distance <= (circle.diameter / 2)
    }
}
