/**
 The `Peg` struct represents a peg in the Peggle-like game. It defines the properties and behavior of a peg.

 ## Invariants:
 - Each peg has a unique identifier (`id`).
 - The peg must have a valid position. i.e. cannot have negative x or y
 - The peg must have a color property (`isBlue`) indicating its color.

 - Note: The `Peg` struct conforms to the `Equatable` protocol, with equality based on the `id` property.

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

struct Peg: Equatable {
    let id: UUID
    private(set) var position: CGPoint
    let isBlue: Bool

    init(id: UUID, position: CGPoint, isBlue: Bool) {
        self.id = id
        self.position = position
        self.isBlue = isBlue

        assert(checkRepresentation())
    }

    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.id == rhs.id
    }

    mutating func setPosition(newPosition: CGPoint) {
        assert(checkRepresentation())

        guard newPosition.x >= 0 && newPosition.y >= 0 else {
            return
        }

        self.position = newPosition

        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        guard position.x >= 0 && position.y >= 0 else {
            return false
        }

        return true
    }
}
