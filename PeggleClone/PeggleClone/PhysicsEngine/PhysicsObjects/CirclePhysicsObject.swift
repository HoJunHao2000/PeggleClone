//
//  CirclePhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import Foundation

class CirclePhysicsObject: PhysicsObject {
    let diameter: Double

    init(position: CGPoint,
         velocity: CGVector,
         force: CGVector,
         isMoveable: Bool,
         diameter: Double,
         elasticity: Double,
         mass: Double = PhysicsObject.DEFAULT_MASS) {
        self.diameter = diameter
        super.init(position: position,
                   velocity: velocity,
                   force: force,
                   isMoveable: isMoveable,
                   elasticity: elasticity,
                   mass: mass)
    }
}
