//
//  Spooky.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 27/2/24.
//

import Foundation

class Spooky: PowerUp {
    func powerup(peg: PegGameObject, gameEngine: GameEngine) {
        guard gameEngine.ball != nil else {
            return
        }

        guard peg.physicsObject.isFirstHit else {
            return
        }

        gameEngine.setIsSpooky()
        peg.physicsObject.incrementHitCount()
    }
}
