/**
 The `Gameboard` struct represents the game board for a Peggle-like game.
 It defines the structure of the gameboard, manages pegs' positions, and enforces specific constraints.

 ## Information contained in `Gameboard`:
 - Rectangular gameboard
 - Pegs on the gameboard

 ## Representation Invariants for Every `Gameboard`:
 - All pegs must be within the boundaries of the gameboard.
 - All blocks must be within the boundaries of the gameboard.
 - Pegs must not overlap with each other.
 - Blocks must not overlap with each other.
 - Pegs must not overlap with blocks.
 - Must have unique identifier

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class Gameboard {
    let id: UUID
    private(set) var name: String
    private(set) var boardSize: CGSize
    private(set) var pegs: [Peg]
    private(set) var blocks: [Block]

    init(id: UUID, name: String, boardSize: CGSize, pegs: [Peg], blocks: [Block]) {
        self.id = id
        self.name = name
        self.boardSize = boardSize
        self.pegs = pegs
        self.blocks = blocks

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

    func addBlock(block: Block) {
        assert(checkRepresentation())

        self.blocks.append(block)

        assert(checkRepresentation())
    }

    func deletePeg(peg: Peg) {
        assert(checkRepresentation())

        self.pegs.removeAll { $0 == peg }

        assert(checkRepresentation())
    }

    func deleteBlock(block: Block) {
        assert(checkRepresentation())

        self.blocks.removeAll { $0 == block }

        assert(checkRepresentation())
    }

    func movePeg(peg: Peg, to location: CGPoint) {
        assert(checkRepresentation())

        if let index = pegs.firstIndex(where: { $0 == peg }) {
            pegs[index].setPosition(newPosition: location)
        }

        assert(checkRepresentation())
    }

    func moveBlock(block: Block, to location: CGPoint) {
        assert(checkRepresentation())

        if let index = blocks.firstIndex(where: { $0 == block }) {
            blocks[index].setPosition(newPosition: location)
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

    func resizeBlockHeight(block: Block, newHeight: Double) {
        assert(checkRepresentation())

        if let index = blocks.firstIndex(where: { $0 == block }) {
            blocks[index].setHeight(newHeight: newHeight)
        }

        assert(checkRepresentation())
    }

    func resizeBlockWidth(block: Block, newWidth: Double) {
        assert(checkRepresentation())

        if let index = blocks.firstIndex(where: { $0 == block }) {
            blocks[index].setWidth(newWidth: newWidth)
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

    func rotateBlock(block: Block, newAngle: Double) {
        assert(checkRepresentation())

        if let index = blocks.firstIndex(where: { $0 == block }) {
            blocks[index].setRotation(newAngle: newAngle)
        }

        assert(checkRepresentation())
    }

    func reset() {
        assert(checkRepresentation())

        self.pegs = []
        self.blocks = []

        assert(checkRepresentation())
    }
}

extension Gameboard {
    private func checkRepresentation() -> Bool {
        // Check if all pegs are within the board
        guard checkRepresentationPegsOnBoard() else {
            return false
        }

        // Check if there is any overlap between pegs
        guard checkRepresentationOverlapBetweenPegs() else {
            return false
        }

        // Check if blocks are within the board
        guard checkRepresentationBlocksOnBoard() else {
            return false
        }

        // Check if any overlap between blocks
        guard checkRepresentationOverlapBetweenBlocks() else {
            return false
        }

        // Check if overlap between blocks and pegs
        guard checkRepresentationPegBlockOverlap() else {
            return false
        }

        return true
    }

    private func checkRepresentationPegsOnBoard() -> Bool {
        for peg in pegs {
            let x1 = peg.position.x - (peg.diameter / 2.0)
            let x2 = peg.position.x + (peg.diameter / 2.0)
            let y1 = peg.position.y - (peg.diameter / 2.0)
            let y2 = peg.position.y + (peg.diameter / 2.0)

            if x1 <= 0 || x2 >= boardSize.width || y1 <= 0 || y2 >= boardSize.height {
                return false
            }
        }

        return true
    }

    private func checkRepresentationOverlapBetweenPegs() -> Bool {
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

    private func checkRepresentationBlocksOnBoard() -> Bool {
        for block in blocks {
            let corners = Utils.cornersOfRect(size: block.size,
                                              position: block.position,
                                              rotation: block.rotation)
            for corner in corners where corner.x <= 0
            || corner.x >= boardSize.width
            || corner.y <= 0
            || corner.y >= boardSize.height {
                return false
            }
        }

        return true
    }

    private func checkRepresentationOverlapBetweenBlocks() -> Bool {
        for (index, block) in blocks.enumerated() {
            let corners1 = Utils.cornersOfRect(size: block.size,
                                               position: block.position,
                                               rotation: block.rotation)
            let isOverlap = blocks.enumerated().contains { otherIndex, otherBlock in
                if index == otherIndex {
                    return false
                }
                let corners2 = Utils.cornersOfRect(size: otherBlock.size,
                                                   position: otherBlock.position,
                                                   rotation: otherBlock.rotation)

                return Utils.checkPolygonOverlap(corners1: corners1, corners2: corners2)
            }

            if isOverlap {
                return false
            }
        }

        return true
    }

    private func checkRepresentationPegBlockOverlap() -> Bool {
        for peg in pegs {
            for block in blocks {
                let blockCorners = Utils.cornersOfRect(size: block.size,
                                                       position: block.position,
                                                       rotation: block.rotation)
                let pegPosition = peg.position
                let pegRadius = peg.diameter / 2

                let corner1 = blockCorners[0]
                let corner2 = blockCorners[1]
                let corner3 = blockCorners[2]
                let corner4 = blockCorners[3]

                let triangle1 = Utils.areaOfTriangle(p1: corner1, p2: pegPosition, p3: corner4)
                let triangle2 = Utils.areaOfTriangle(p1: corner4, p2: pegPosition, p3: corner3)
                let triangle3 = Utils.areaOfTriangle(p1: corner3, p2: pegPosition, p3: corner2)
                let triangle4 = Utils.areaOfTriangle(p1: corner1, p2: pegPosition, p3: corner2)

                if triangle1 + triangle2 + triangle3 + triangle4 <= block.height * block.width {
                    return false
                }

                // Check if any of rectangle edges intersect the circle
                for i in 0..<4 {
                    let j = (i + 1) % 4
                    let closestPoint = Utils.closestPointOnLine(to: pegPosition,
                                                                lineStart: blockCorners[i],
                                                                lineEnd: blockCorners[j])
                    let distance = Utils.distanceBetween(point1: closestPoint, point2: pegPosition)

                    if distance <= pegRadius {
                        return false
                    }
                }
            }
        }

        return true
    }
}
