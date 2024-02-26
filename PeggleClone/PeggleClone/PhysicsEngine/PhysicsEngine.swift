/**
The `PhysicsEngine` class manages the physics simulation for a Peggle-like game.
It handles the addition and removal of physics objects, updating their positions of physics obejcts.

## Information contained in `PhysicsEngine`:
- Array of PhysicsObject instances representing the physical objects in the simulation.

## Representation Invariants for Every `PhysicsEngine`:
- The array of PhysicsObject instances must not contain any duplicate objects.

Authors: CS3217, HoJunHao2000
*/

import Foundation

class PhysicsEngine {
    private(set) var physicsObjects: [PhysicsObject] = []

    private let collisionHandler = CollisionDelegate()
    private let intersector = IntersectorDelegate()

    func addPhysicsObject(physicsObject: PhysicsObject) {
        guard !Set(physicsObjects).contains(physicsObject) else {
            return
        }
        physicsObjects.append(physicsObject)
    }

    func removePhysicsObject(physicsObject: PhysicsObject) {
        physicsObjects.removeAll(where: { $0 === physicsObject })
    }

    func resetAllHitCount() {
        physicsObjects.forEach { $0.resetHitCount() }
    }

    func updatePhysicsObjects(timeDelta: TimeInterval) {
        guard timeDelta > 0 else {
            return
        }
        physicsObjects.forEach({ $0.update(timeDelta: timeDelta) })
        resolveAllCollisions()
    }

    func resolveAllCollisions() {
        for i in 0..<physicsObjects.count {
            for j in (i + 1)..<physicsObjects.count {
                let physicsObjectOne = physicsObjects[i]
                let physicsObjectTwo = physicsObjects[j]

                handleCollisionBetween(objectA: physicsObjectOne, objectB: physicsObjectTwo)
            }
        }
    }

    private func handleCollisionBetween(objectA: PhysicsObject, objectB: PhysicsObject) {
        guard intersector.intersects(object1: objectA, object2: objectB) else {
            return
        }
        collisionHandler.handleCollision(object1: objectA, object2: objectB)
    }

    private func checkRepresentation() -> Bool {
        // no duplicate physicsObjects
        guard Set(physicsObjects).count == physicsObjects.count else {
            return false
        }

        return true
    }
}
