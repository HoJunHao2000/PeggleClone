//
//  RectPhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 26/2/24.
//

import Foundation

class RectPhysicsObject: PhysicsObject {
    let size: CGSize
    let rotation: Double

    init(position: CGPoint,
         size: CGSize,
         elasticity: Double,
         rotation: Double = 0,
         velocity: CGVector = .zero,
         isMoveable: Bool = false) {
        self.size = size
        self.rotation = rotation
        super.init(position: position,
                   velocity: velocity,
                   force: CGVector(dx: 0, dy: 0),
                   isMoveable: isMoveable,
                   elasticity: elasticity)
    }
}
