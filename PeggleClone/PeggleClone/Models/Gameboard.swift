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

struct Gameboard {
    let id: UUID
    private(set) var name: String
    private(set) var boardSize: CGSize
    private(set) var pegs: [Peg]

    private static let edgeMargin: CGFloat = 25.0
    private static let minDistanceBetweenPegs: CGFloat = 50.0

    init(id: UUID, name: String, boardSize: CGSize, pegs: [Peg]) {
        self.id = id
        self.name = name
        self.boardSize = boardSize
        self.pegs = pegs

        assert(checkRepresentation())
    }

    mutating func setName(newName: String) {
        assert(checkRepresentation())

        self.name = newName

        assert(checkRepresentation())
    }

    mutating func setBoardSize(newSize: CGSize) {
        assert(checkRepresentation())

        guard isPegsWithinNewBoard(newSize: newSize) else {
            return
        }
        self.boardSize = newSize

        assert(checkRepresentation())
    }

    mutating func addPeg(at location: CGPoint, isBlue: Bool) {
        assert(checkRepresentation())

        guard isValidLocation(point: location) else {
            return
        }

        self.pegs.append(Peg(id: UUID(), position: location, isBlue: isBlue))

        assert(checkRepresentation())
    }

    mutating func deletePeg(index: Int) {
        assert(checkRepresentation())

        guard index >= 0, index < self.pegs.count else {
            return
        }

        self.pegs.remove(at: index)

        assert(checkRepresentation())
    }

    mutating func movePeg(at index: Int, to location: CGPoint) {
        assert(checkRepresentation())

        guard index >= 0, index < self.pegs.count else {
            return
        }

        guard isValidLocation(point: location, at: index) else {
            return
        }

        pegs[index].setPosition(newPosition: location)

        assert(checkRepresentation())
    }

    mutating func reset() {
        assert(checkRepresentation())

        self.pegs = []

        assert(checkRepresentation())
    }

    private func isPegsWithinNewBoard(newSize: CGSize) -> Bool {
        let halfWidth = newSize.width / 2.0
            let halfHeight = newSize.height / 2.0

        for peg in self.pegs {
            let deltaX = abs(peg.position.x - newSize.width / 2.0)
            let deltaY = abs(peg.position.y - newSize.height / 2.0)

            if deltaX > halfWidth || deltaY > halfHeight {
                return false
            }
        }

        return true
    }

    private func isValidLocation(point: CGPoint, at: Int? = nil) -> Bool {
        // Checks if point is within bounds of the gameboard
        guard CGRect(x: Gameboard.edgeMargin,
                     y: Gameboard.edgeMargin,
                     width: self.boardSize.width - 2 * Gameboard.edgeMargin,
                     height: self.boardSize.height - 2 * Gameboard.edgeMargin).contains(point) else {
            return false
        }

        // Checks if peg overlaps with other pegs
        let isOverlap = self.pegs.enumerated().contains { index, existingPeg in
            if at == index {
                return false
            }
            return arePegsOverlapping(existingPeg.position, point)
        }

        return !isOverlap
    }

    private func arePegsOverlapping(_ position1: CGPoint, _ position2: CGPoint) -> Bool {
        let distance = sqrt(pow(position1.x - position2.x, 2) + pow(position1.y - position2.y, 2))
        return distance < Gameboard.minDistanceBetweenPegs
    }

    private func checkRepresentation() -> Bool {
        // Check if all pegs are within the board
        guard isPegsWithinNewBoard(newSize: boardSize) else {
            return false
        }

        // Check if there is any overlap between pegs
        for (index, peg) in pegs.enumerated() {
            let pegPosition = peg.position
            let isOverlap = pegs.enumerated().contains { otherIndex, otherPeg in
                if index == otherIndex {
                    return false
                }
                return arePegsOverlapping(pegPosition, otherPeg.position)
            }

            if isOverlap {
                return false
            }
        }

        return true
    }
}
