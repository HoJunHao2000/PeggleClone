//
//  BucketPhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 27/2/24.
//

import Foundation

class BucketPhysicsObject: PhysicsObject {
    let corners: [CGPoint]

    init(position: CGPoint, corners: [CGPoint]) {
        self.corners = corners
        super.init(position: position,
                   velocity: CGVector(dx: 100, dy: 0),
                   force: CGVector(dx: 0, dy: 0),
                   isMoveable: true,
                   elasticity: 1)
    }
}
