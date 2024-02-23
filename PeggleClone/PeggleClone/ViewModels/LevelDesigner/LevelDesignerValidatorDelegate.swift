//
//  LevelDesignerValidatorDelegate.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 23/2/24.
//

import Foundation

class LevelDesignerValidatorDelegate {
    func arePegsWithinBoard(boardSize: CGSize, pegs: [Peg]) -> Bool {
        for peg in pegs where !isPegWithinBoard(boardSize: boardSize, peg: peg) {
            return false
        }

        return true
    }

    func isValidLocation(newPeg: Peg, boardSize: CGSize, pegs: [Peg]) -> Bool {
        // Checks if newPeg is within bounds of the gameboard
        guard !isPegWithinBoard(boardSize: boardSize, peg: newPeg) else {
            return false
        }

        // Checks if peg overlaps with other pegs
        let isOverlap = pegs.enumerated().contains { _, existingPeg in
            arePegsOverlapping(peg1: existingPeg, peg2: newPeg)
        }

        return !isOverlap
    }

    func isValidLocation(point: CGPoint, peg: Peg, gameboard: Gameboard) -> Bool {
        let boardSize = gameboard.boardSize
        let pegs = gameboard.pegs

        let oldPegPosition = peg.position
        peg.setPosition(newPosition: point)

        // Checks if peg is within bounds of the gameboard
        guard !isPegWithinBoard(boardSize: boardSize, peg: peg) else {
            peg.setPosition(newPosition: oldPegPosition)
            return false
        }

        // Checks if peg overlaps with other pegs
        let isOverlap = pegs.enumerated().contains { _, existingPeg in
            guard existingPeg == peg else {
                return false
            }
            return arePegsOverlapping(peg1: existingPeg, peg2: peg)
        }

        peg.setPosition(newPosition: oldPegPosition)
        return !isOverlap
    }

    func isValidSize(peg: Peg, diameter: Double, gameboard: Gameboard) -> Bool {
        let boardSize = gameboard.boardSize
        let pegs = gameboard.pegs

        let oldPegDiameter = peg.diameter
        peg.setDiameter(newDiameter: diameter)

        // Checks if peg is within bounds of the gameboard
        guard !isPegWithinBoard(boardSize: boardSize, peg: peg) else {
            peg.setDiameter(newDiameter: oldPegDiameter)
            return false
        }

        // Checks if peg overlaps with other pegs
        let isOverlap = pegs.enumerated().contains { _, existingPeg in
            guard existingPeg == peg else {
                return false
            }
            return arePegsOverlapping(peg1: existingPeg, peg2: peg)
        }

        peg.setDiameter(newDiameter: oldPegDiameter)
        return !isOverlap
    }

    func arePegsOverlapping(peg1: Peg, peg2: Peg) -> Bool {
        let distance = sqrt(pow(peg1.position.x - peg2.position.x, 2) + pow(peg1.position.y - peg2.position.y, 2))
        let combinedRadius = (peg1.diameter / 2) + (peg2.diameter / 2)
        return distance <= combinedRadius
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
}
