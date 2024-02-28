/**
 The `PegGameObject` class represents a peg for a Peggle-like game.

 ## Information contained in `PegGameObject`:
 - A cirle physics object
 - A peg model information

 ## Representation Invariants for Every `PegGameObject`:
 - All PegGameObject must have a circle physics object and Peg
 
 Since physicsObject and Peg are compulsory fields, there will never be a situation where its
 missing hence checkRepresentation function not implemented for this.

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class PegGameObject {
    static let MAX_HIT_COUNT: Int = 240
    static let DEFAULT_PEG_ELASTICITY: Double = 0.6

    static let pegTypePowerUpMap: [PegType: PowerUp] = [
        .KaboomPeg: KaBoom(),
        .SpookyPeg: Spooky()
    ]

    private(set) var physicsObject: CirclePhysicsObject
    let pegtype: PegType
    let powerup: PowerUp?

    init(peg: Peg) {
        self.physicsObject = CirclePhysicsObject(position: peg.position,
                                                 velocity: CGVector(dx: 0, dy: 0),
                                                 force: CGVector(dx: 0, dy: 0),
                                                 isMoveable: false,
                                                 diameter: peg.diameter,
                                                 elasticity: PegGameObject.DEFAULT_PEG_ELASTICITY)
        self.pegtype = peg.pegtype
        self.powerup = PegGameObject.pegTypePowerUpMap[peg.pegtype]
    }

    var diameter: Double {
        physicsObject.diameter
    }

    var position: CGPoint {
        physicsObject.position
    }

    var isLit: Bool {
        physicsObject.hitCount > 0
    }

    var shouldRemove: Bool {
        physicsObject.hitCount > PegGameObject.MAX_HIT_COUNT
    }
}

extension PegGameObject: Hashable {
    static func == (lhs: PegGameObject, rhs: PegGameObject) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
