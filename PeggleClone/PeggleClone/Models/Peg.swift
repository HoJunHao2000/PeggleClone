/**
 The `Peg` struct represents a peg in the Peggle-like game. It defines the properties and behavior of a peg.

 ## Invariants:
 - Each peg has a unique identifier (`id`).
 - The peg must have a valid position. i.e. cannot have negative x or y
 - The peg must have a valid diameter. i.e. must be greater than 0
 - The peg must have a rotation.
 - The peg must have a type  property (`pegtype`) indicating what kind of peg it is.

 - Note: The `Peg` struct conforms to the `Equatable` protocol, with equality based on the `id` property.

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class Peg {
    static let DEFAULT_PEG_DIAMETER: Double = 50
    private static let DEFAULT_PEG_ANGLE: Double = 0

    let id: UUID
    let pegtype: PegType
    private(set) var position: CGPoint
    private(set) var diameter: Double
    private(set) var rotation: Double

    init(id: UUID,
         position: CGPoint,
         pegtype: PegType,
         diameter: Double = Peg.DEFAULT_PEG_DIAMETER,
         rotation: Double = Peg.DEFAULT_PEG_ANGLE) {
        self.id = id
        self.position = position
        self.diameter = diameter
        self.rotation = rotation
        self.pegtype = pegtype

        assert(checkRepresentation())
    }

    func setPosition(newPosition: CGPoint) {
        assert(checkRepresentation())

        guard newPosition.x >= 0 && newPosition.y >= 0 else {
            return
        }

        self.position = newPosition

        assert(checkRepresentation())
    }

    func setRotation(newAngle: Double) {
        assert(checkRepresentation())

        self.rotation = newAngle

        assert(checkRepresentation())
    }

    func setDiameter(newDiameter: Double) {
        assert(checkRepresentation())

        self.diameter = newDiameter

        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        guard position.x >= 0 && position.y >= 0 && diameter > 0 else {
            return false
        }

        return true
    }
}

extension Peg: Hashable {
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.id == rhs.id || lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
