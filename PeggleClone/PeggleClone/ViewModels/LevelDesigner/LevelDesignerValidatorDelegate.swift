//
//  LevelDesignerValidatorDelegate.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 23/2/24.
//

import Foundation

class LevelDesignerValidatorDelegate {
    func arePegsAndBlocksWithinBoard(boardSize: CGSize, gameboard: Gameboard) -> Bool {
        for block in gameboard.blocks where !isBlockWithinBoard(boardSize: boardSize, block: block) {
            return false
        }

        for peg in gameboard.pegs where !isPegWithinBoard(boardSize: boardSize, peg: peg) {
            return false
        }

        return true
    }

    func isValidLocation(newPeg: Peg, gameboard: Gameboard) -> Bool {
        // Checks if newPeg is within bounds of the gameboard
        guard isPegWithinBoard(boardSize: gameboard.boardSize, peg: newPeg) else {
            return false
        }

        // Checks if peg is in bucket region
        guard !isPegInBucketRegion(peg: newPeg, gameboard: gameboard) else {
            return false
        }

        // Checks if peg overlaps with other pegs
        for peg in gameboard.pegs where arePegsOverlapping(peg1: newPeg, peg2: peg) {
            return false
        }

        // Checks if peg overlaps with other blocks
        for block in gameboard.blocks where arePegBlockOverlapping(peg: newPeg, block: block) {
            return false
        }

        return true
    }

    func isValidLocation(newBlock: Block, gameboard: Gameboard) -> Bool {
        // Checks if newBlock is within bounds of gameboard
        guard isBlockWithinBoard(boardSize: gameboard.boardSize, block: newBlock) else {
            return false
        }

        // Checks if block is in bucket region
        guard !isBlockInBucketRegion(block: newBlock, gameboard: gameboard) else {
            return false
        }

        // Check if block overlaps with other blocks
        for block in gameboard.blocks where areBlocksOverlapping(block1: block, block2: newBlock) {
            return false
        }

        // Check if block overlaps with other pegs
        for pegs in gameboard.pegs where arePegBlockOverlapping(peg: pegs, block: newBlock) {
            return false
        }

        return true
    }

    func isValidLocation(point: CGPoint, peg: Peg, gameboard: Gameboard) -> Bool {
        let oldPegPosition = peg.position

        peg.setPosition(newPosition: point)
        let result = isValidPegModification(peg: peg, gameboard: gameboard)
        peg.setPosition(newPosition: oldPegPosition)

        return result
    }

    func isValidLocation(point: CGPoint, block: Block, gameboard: Gameboard) -> Bool {
        let oldBlockPosition = block.position

        block.setPosition(newPosition: point)
        let result = isValidBlockModification(block: block, gameboard: gameboard)
        block.setPosition(newPosition: oldBlockPosition)

        return result
    }

    func isValidSize(peg: Peg, diameter: Double, gameboard: Gameboard) -> Bool {
        let oldPegDiameter = peg.diameter

        peg.setDiameter(newDiameter: diameter)
        let result = isValidPegModification(peg: peg, gameboard: gameboard)
        peg.setDiameter(newDiameter: oldPegDiameter)

        return result
    }

    func isValidBlockRotation(block: Block, newRotation: Double, gameboard: Gameboard) -> Bool {
        let oldBlockRotation = block.rotation

        block.setRotation(newAngle: newRotation)
        let result = isValidBlockModification(block: block, gameboard: gameboard)
        block.setRotation(newAngle: oldBlockRotation)

        return result
    }

    func isValidBlockHeight(block: Block, newHeight: Double, gameboard: Gameboard) -> Bool {
        let oldBlockHeight = block.height

        block.setHeight(newHeight: newHeight)
        let result = isValidBlockModification(block: block, gameboard: gameboard)
        block.setHeight(newHeight: oldBlockHeight)

        return result
    }

    func isValidBlockWidth(block: Block, newWidth: Double, gameboard: Gameboard) -> Bool {
        let oldBlockWidth = block.width

        block.setWidth(newWidth: newWidth)
        let result = isValidBlockModification(block: block, gameboard: gameboard)
        block.setWidth(newWidth: oldBlockWidth)

        return result
    }

    private func arePegsOverlapping(peg1: Peg, peg2: Peg) -> Bool {
        let distance = Utils.distanceBetween(point1: peg1.position, point2: peg2.position)
        let combinedRadius = (peg1.diameter / 2) + (peg2.diameter / 2)
        return distance <= combinedRadius
    }

    private func areBlocksOverlapping(block1: Block, block2: Block) -> Bool {
        let corners1 = Utils.cornersOfRect(size: block1.size,
                                           position: block1.position,
                                           rotation: block1.rotation)
        let corners2 = Utils.cornersOfRect(size: block2.size,
                                           position: block2.position,
                                           rotation: block2.rotation)

        return Utils.checkPolygonOverlap(corners1: corners1, corners2: corners2)
    }

    private func arePegBlockOverlapping(peg: Peg, block: Block) -> Bool {
        let blockCorners = Utils.cornersOfRect(size: block.size,
                                               position: block.position,
                                               rotation: block.rotation)
        let pegPosition = peg.position
        let pegRadius = peg.diameter / 2

        // Check if peg's centre is within block
        guard !isPegInsideBlock(block: block, peg: peg) else {
            return true
        }

        // Check if any of rectangle edges intersect the circle
        for i in 0..<4 {
            let j = (i + 1) % 4
            let closestPoint = Utils.closestPointOnLine(to: pegPosition,
                                                        lineStart: blockCorners[i],
                                                        lineEnd: blockCorners[j])
            let distance = Utils.distanceBetween(point1: closestPoint, point2: pegPosition)

            if distance <= pegRadius {
                return true
            }
        }

        return false
    }

    private func isPegWithinBoard(boardSize: CGSize, peg: Peg) -> Bool {
        let x1 = peg.position.x - (peg.diameter / 2.0)
        let x2 = peg.position.x + (peg.diameter / 2.0)
        let y1 = peg.position.y - (peg.diameter / 2.0)
        let y2 = peg.position.y + (peg.diameter / 2.0)

        if x1 <= 0 || x2 >= boardSize.width || y1 <= 0 || y2 >= boardSize.height {
            return false
        }

        return true
    }

    private func isBlockWithinBoard(boardSize: CGSize, block: Block) -> Bool {
        let corners = Utils.cornersOfRect(size: block.size,
                                          position: block.position,
                                          rotation: block.rotation)
        for corner in corners where corner.x <= 0
        || corner.x >= boardSize.width
        || corner.y <= 0
        || corner.y >= boardSize.height {
            return false
        }
        return true
    }

    private func isPegInsideBlock(block: Block, peg: Peg) -> Bool {
        let point = peg.position
        let blockArea = block.height * block.width
        let blockCorners = Utils.cornersOfRect(size: block.size,
                                               position: block.position,
                                               rotation: block.rotation)

        let corner1 = blockCorners[0]
        let corner2 = blockCorners[1]
        let corner3 = blockCorners[2]
        let corner4 = blockCorners[3]

        let triangle1 = Utils.areaOfTriangle(p1: corner1, p2: point, p3: corner4)
        let triangle2 = Utils.areaOfTriangle(p1: corner4, p2: point, p3: corner3)
        let triangle3 = Utils.areaOfTriangle(p1: corner3, p2: point, p3: corner2)
        let triangle4 = Utils.areaOfTriangle(p1: corner1, p2: point, p3: corner2)

        return triangle1 + triangle2 + triangle3 + triangle4 <= blockArea
    }

    private func isValidBlockModification(block: Block, gameboard: Gameboard) -> Bool {
        // Check if block is within bound of gameboard
        guard isBlockWithinBoard(boardSize: gameboard.boardSize, block: block) else {
            return false
        }

        // Checks if block is in bucket region
        guard !isBlockInBucketRegion(block: block, gameboard: gameboard) else {
            return false
        }

        // Check for peg overlaps
        for peg in gameboard.pegs where arePegBlockOverlapping(peg: peg, block: block) {
            return false
        }

        // Check for block overlaps
        for existingBlock in gameboard.blocks
        where existingBlock != block && areBlocksOverlapping(block1: block, block2: existingBlock) {
            return false
        }

        return true
    }

    private func isValidPegModification(peg: Peg, gameboard: Gameboard) -> Bool {
        // Check if peg is within bound of gameboard
        guard isPegWithinBoard(boardSize: gameboard.boardSize, peg: peg) else {
            return false
        }

        // Checks if peg is in bucket region
        guard !isPegInBucketRegion(peg: peg, gameboard: gameboard) else {
            return false
        }

        // Check for peg overlaps
        for existingPeg in gameboard.pegs
        where existingPeg != peg && arePegsOverlapping(peg1: peg, peg2: existingPeg) {
            return false
        }

        // Check for block overlaps
        for block in gameboard.blocks where arePegBlockOverlapping(peg: peg, block: block) {
            return false
        }

        return true
    }

    private func isPegInBucketRegion(peg: Peg, gameboard: Gameboard) -> Bool {
        let positionY = peg.position.y
        let radius = peg.diameter / 2
        let bucketHeight = 100.0
        let bottomOfBoard = gameboard.boardSize.height

        if positionY + radius + bucketHeight >= bottomOfBoard {
            return true
        }

        return false
    }

    private func isBlockInBucketRegion(block: Block, gameboard: Gameboard) -> Bool {
        let cornersOfBlock = Utils.cornersOfRect(size: block.size, position: block.position, rotation: block.rotation)
        let maxY = cornersOfBlock.max(by: { $0.y < $1.y })?.y ?? 0
        let bucketHeight = 100.0
        let bottomOfBoard = gameboard.boardSize.height

        if maxY + bucketHeight >= bottomOfBoard {
            return true
        }

        return false
    }
}
