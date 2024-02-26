//
//  BlockPhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 26/2/24.
//

import Foundation

class BlockPhysicsObject: PhysicsObject {
    let size: CGSize
    let rotation: Double

    init(position: CGPoint, size: CGSize, rotation: Double, elasticity: Double) {
        self.size = size
        self.rotation = rotation
        super.init(position: position,
                   velocity: CGVector(dx: 0, dy: 0),
                   force: CGVector(dx: 0, dy: 0),
                   isMoveable: false,
                   elasticity: elasticity)
    }
}
