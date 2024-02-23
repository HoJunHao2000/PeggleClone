/**
 The `Gameboard` struct represents the game board for a Peggle-like game.
 It defines the structure of the gameboard, manages pegs' positions, and enforces specific constraints.

 ## Information contained in `Gameboard`:
 - Rectangular gameboard
 - Pegs on the gameboard

 ## Representation Invariants for Every `Gameboard`:
 - All pegs must be within the boundaries of the gameboard.
 - Pegs must not overlap with each other.
 - Must have unique identifier

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class Gameboard {
    let id: UUID
    private(set) var name: String
    private(set) var boardSize: CGSize
    private(set) var pegs: [Peg]

    init(id: UUID, name: String, boardSize: CGSize, pegs: [Peg]) {
        self.id = id
        self.name = name
        self.boardSize = boardSize
        self.pegs = pegs

        assert(checkRepresentation())
    }

    func setName(newName: String) {
        assert(checkRepresentation())

        self.name = newName

        assert(checkRepresentation())
    }

    func setBoardSize(newSize: CGSize) {
        assert(checkRepresentation())

        self.boardSize = newSize

        assert(checkRepresentation())
    }

    func addPeg(peg: Peg) {
        assert(checkRepresentation())

        self.pegs.append(peg)

        assert(checkRepresentation())
    }

    func deletePeg(peg: Peg) {
        assert(checkRepresentation())

        self.pegs.removeAll { $0 == peg }

        assert(checkRepresentation())
    }

    func movePeg(peg: Peg, to location: CGPoint) {
        assert(checkRepresentation())

        if let index = pegs.firstIndex(where: { $0 == peg }) {
            pegs[index].setPosition(newPosition: location)
        }

        assert(checkRepresentation())
    }

    func resizePeg(peg: Peg, newDiameter: Double) {
        assert(checkRepresentation())

        if let index = pegs.firstIndex(where: { $0 == peg }) {
            pegs[index].setDiameter(newDiameter: newDiameter)
        }

        assert(checkRepresentation())
    }

    func rotatePeg(peg: Peg, newAngle: Double) {
        assert(checkRepresentation())

        if let index = pegs.firstIndex(where: { $0 == peg }) {
            pegs[index].setRotation(newAngle: newAngle)
        }

        assert(checkRepresentation())
    }

    func reset() {
        assert(checkRepresentation())

        self.pegs = []

        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        // Check if all pegs are within the board
        for peg in pegs {
            let x1 = peg.position.x - (peg.diameter / 2.0)
            let x2 = peg.position.x + (peg.diameter / 2.0)
            let y1 = peg.position.y - (peg.diameter / 2.0)
            let y2 = peg.position.y + (peg.diameter / 2.0)

            if x1 <= 0 || x2 >= boardSize.width || y1 <= 0 || y2 >= boardSize.height {
                return false
            }
        }

        // Check if there is any overlap between pegs
        for (index, peg) in pegs.enumerated() {
            let isOverlap = pegs.enumerated().contains { otherIndex, otherPeg in
                if index == otherIndex {
                    return false
                }
                let distance = sqrt(pow(peg.position.x - otherPeg.position.x, 2)
                                    + pow(peg.position.y - otherPeg.position.y, 2))
                let combinedRadius = (peg.diameter / 2) + (otherPeg.diameter / 2)
                return distance <= combinedRadius
            }

            if isOverlap {
                return false
            }
        }

        return true
    }
}
