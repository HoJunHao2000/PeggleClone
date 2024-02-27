/**
The `PhysicsObject` class represents a physical object in a physics simulation.
It defines the properties and behaviors of the object, such as its position, velocity, mass, and forces acting upon it.

## Information contained in `PhysicsObject`:
- Position of the object
- Velocity of the object
- Force acting upon the object
- Mass of the object
- Whether the object is movable
- Elasticity of the object

## Representation Invariants for Every `PhysicsObject`:
- The hit count must be non-negative.
- The mass must be non-negative.
- The elasticity must be non-negative.

- Authors: CS3217, HoJunHao2000
*/

import Foundation

class PhysicsObject {
    static let DEFAULT_MASS = Double.infinity
    static let DEFAULT_ELASTICITY: Double = 1

    private(set) var position: CGPoint
    private(set) var velocity: CGVector
    private(set) var force: CGVector
    private(set) var hitCount: Int

    let mass: Double
    let isMoveable: Bool
    let elasticity: Double

    init(position: CGPoint,
         velocity: CGVector,
         force: CGVector,
         isMoveable: Bool,
         elasticity: Double = PhysicsObject.DEFAULT_ELASTICITY,
         mass: Double = PhysicsObject.DEFAULT_MASS) {
        self.position = position
        self.velocity = velocity
        self.force = force
        self.hitCount = 0
        self.isMoveable = isMoveable
        self.mass = mass
        self.elasticity = elasticity
    }

    var isFirstHit: Bool {
        hitCount == 1
    }

    func incrementHitCount() {
        hitCount += 1
    }

    func setHitCount(newHitCount: Int) {
        guard newHitCount > 0 else {
            return
        }

        hitCount = newHitCount
    }

    func setVelocity(newVelocity: CGVector) {
        self.velocity = newVelocity
    }

    func setPosition(newPosition: CGPoint) {
        self.position = newPosition
    }

    func resetHitCount() {
        self.hitCount = 0
    }

    func update(timeDelta: TimeInterval) {
        guard isMoveable else {
            return
        }

        guard timeDelta > 0 else {
            return
        }

        // Update position using the formula: s = ut + (1/2) * a * t^2
        let deltaX = velocity.dx * timeDelta + 0.5 * force.dx * pow(timeDelta, 2)
        let deltaY = velocity.dy * timeDelta + 0.5 * force.dy * pow(timeDelta, 2)

        // Update velocity using the formula: v = u + at
        velocity.dx += force.dx * CGFloat(timeDelta)
        velocity.dy += force.dy * CGFloat(timeDelta)

        position.x += deltaX
        position.y += deltaY
    }

    private func checkRepresentation() -> Bool {
        // no negative hit count
        guard hitCount >= 0 else {
            return false
        }

        // no negative mass
        guard mass >= 0 else {
            return false
        }

        // no negative elasticity
        guard elasticity >= 0 else {
            return false
        }

        return true
    }
}

extension PhysicsObject: Hashable {
    static func == (lhs: PhysicsObject, rhs: PhysicsObject) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
