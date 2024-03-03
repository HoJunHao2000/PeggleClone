/**
The `PhysicsEngine` class manages the physics simulation for a Peggle-like game.
It handles the addition and removal of physics objects, updating their positions of physics obejcts.

## Representation Invariants for Every `PhysicsEngine`:
- The array of PhysicsObject instances must not contain any duplicate objects.

Authors: CS3217, HoJunHao2000
*/

import Foundation

class PhysicsEngine {
    private(set) var physicsObjects: [PhysicsObject] = []

    func addPhysicsObject(physicsObject: PhysicsObject) {
        guard !Set(physicsObjects).contains(physicsObject) else {
            return
        }

        physicsObjects.append(physicsObject)
    }

    func removePhysicsObject(physicsObject: PhysicsObject) {
        physicsObjects.removeAll(where: { $0 === physicsObject })
    }

    func updatePhysicsObjects(timeDelta: TimeInterval) {
        guard timeDelta > 0 else {
            return
        }

        physicsObjects.forEach({ $0.update(timeDelta: timeDelta) })
        resolveAllCollisions()
    }

    private func resolveAllCollisions() {
        for i in 0..<physicsObjects.count {
            for j in (i + 1)..<physicsObjects.count {
                let physicsObjectOne = physicsObjects[i]
                let physicsObjectTwo = physicsObjects[j]

                if physicsObjectOne.intersects(physicsObjectTwo) {
                    physicsObjectOne.collides(physicsObjectTwo)
                }
            }
        }
    }

    private func checkRepresentation() -> Bool {
        // no duplicate physicsObjects
        guard Set(physicsObjects).count == physicsObjects.count else {
            return false
        }

        return true
    }
}
