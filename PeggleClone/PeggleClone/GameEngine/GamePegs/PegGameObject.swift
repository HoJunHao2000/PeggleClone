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
    static let MAX_HIT_COUNT: Int = 120
    static let DEFAULT_PEG_ELASTICITY: Double = 0.6

    private(set) var physicsObject: CirclePhysicsObject
    let pegtype: PegType
    let powerup: PowerUp?

    init(powerup: PowerUp?, pegtype: PegType, physicsBody: CirclePhysicsObject) {
        self.pegtype = pegtype
        self.powerup = powerup
        self.physicsObject = physicsBody
    }

    var hitCount: Int {
        physicsObject.hitCount
    }

    var diameter: Double {
        physicsObject.diameter
    }

    var rotation: Double {
        physicsObject.rotation
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
