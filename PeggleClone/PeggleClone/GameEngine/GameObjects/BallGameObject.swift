/**
 The `BallGameObject` class represents a ball for a Peggle-like game.

 ## Information contained in `BallGameObject`:
 - A cirle physics object

 ## Representation Invariants for Every `BallGameObject`:
 - All BallGameObject must have a circle physics object
 
 Since physicsObject is a compulsory field, there will never be a situation where its
 missing hence checkRepresentation function not implemented for this.

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class BallGameObject {
    static let DEFAULT_BALL_DIAMETER: Double = 30
    static let DEFAULT_BALL_MASS: Double = 50
    static let DEFAULT_BALL_ELASTICITY: Double = 1

    private(set) var physicsObject: CirclePhysicsObject

    init(initialPosition: CGPoint, initialForce: CGVector, initialVelocity: CGVector, diameter: Double) {
        self.physicsObject = CirclePhysicsObject(position: initialPosition,
                                                 velocity: initialVelocity,
                                                 force: initialForce,
                                                 isMoveable: true,
                                                 diameter: BallGameObject.DEFAULT_BALL_DIAMETER,
                                                 elasticity: BallGameObject.DEFAULT_BALL_ELASTICITY,
                                                 mass: BallGameObject.DEFAULT_BALL_MASS)
    }

    var position: CGPoint {
        physicsObject.position
    }

    var diameter: Double {
        physicsObject.diameter
    }
}
