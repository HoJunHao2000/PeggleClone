//
//  StubbornPegGameObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 29/2/24.
//

import Foundation

class StubbornPegGameObject: PegGameObject {
    init(peg: Peg) {
        let physicsBody = CirclePhysicsObject(position: peg.position,
                                              velocity: .zero,
                                              force: .zero,
                                              isMoveable: true,
                                              diameter: peg.diameter,
                                              elasticity: 0.9,
                                              mass: peg.diameter * 4)
        let powerup: PowerUp? = nil
        let pegtype = peg.pegtype
        super.init(powerup: powerup, pegtype: pegtype, physicsBody: physicsBody)
    }

    override var isLit: Bool {
        false
    }

    override var shouldRemove: Bool {
        false
    }
}
