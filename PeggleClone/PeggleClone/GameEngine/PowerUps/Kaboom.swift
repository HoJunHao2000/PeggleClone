//
//  Kaboom.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 27/2/24.
//

import Foundation

class Kaboom: PowerUp {
    static let EXPLOSION_RADIUS = 100.0

    func powerup(peg: PegGameObject, gameEngine: GameEngine) {

        guard let ball = gameEngine.ball else {
            return
        }

        guard peg.physicsObject.isFirstHit else {
            return
        }

        peg.physicsObject.incrementHitCount()

        let maxDistance = Kaboom.EXPLOSION_RADIUS + (peg.diameter / 2) + (ball.diameter / 2)
        if Utils.distanceBetween(point1: ball.position, point2: peg.position) < maxDistance {
            let vector = Utils.vectorBetweenTwoPoints(ball.position, peg.position)
            let normalisedVector = Utils.normalize(vector)
            let newVelocity = Utils.scaleBy(normalisedVector, n: GameEngine.INIITAL_BALL_SPEED * 1.5)
            ball.physicsObject.setVelocity(newVelocity: newVelocity)
        }

        for otherPeg in gameEngine.pegs
        where otherPeg != peg && !gameEngine.removedPegs.contains(otherPeg) {
            let maxDistance = Kaboom.EXPLOSION_RADIUS + (otherPeg.diameter / 2) + (peg.diameter / 2)
            if Utils.distanceBetween(point1: otherPeg.position, point2: peg.position) <= maxDistance {
                otherPeg.physicsObject.incrementHitCount()
                otherPeg.powerup?.powerup(peg: otherPeg, gameEngine: gameEngine)
                if otherPeg.pegtype != .KaboomPeg {
                    otherPeg.physicsObject.setHitCount(newHitCount: PegGameObject.MAX_HIT_COUNT + 1)
                }
            }
        }

        peg.physicsObject.setHitCount(newHitCount: PegGameObject.MAX_HIT_COUNT + 1)

        SoundManager.instance.playSound(.boom)
    }
}
