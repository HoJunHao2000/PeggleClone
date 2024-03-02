//
//  KaboomPegGameObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 29/2/24.
//

import Foundation

class KaboomPegGameObject: PegGameObject {
    init(peg: Peg) {
        let physicsBody = CirclePhysicsObject(position: peg.position,
                                              velocity: .zero,
                                              force: .zero,
                                              isMoveable: false,
                                              diameter: peg.diameter,
                                              elasticity: PegGameObject.DEFAULT_PEG_ELASTICITY,
                                              rotation: peg.rotation,
                                              mass: peg.diameter)
        let powerup: PowerUp? = Kaboom()
        let pegtype = peg.pegtype
        super.init(powerup: powerup, pegtype: pegtype, physicsBody: physicsBody)
    }
}
