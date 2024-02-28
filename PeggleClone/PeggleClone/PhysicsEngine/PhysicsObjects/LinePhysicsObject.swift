//
//  LinePhysicsObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import Foundation

class LinePhysicsObject: PhysicsObject {
    static let DEFAULT_LINE_ELASTICITY: Double = 0.95

    let startPoint: CGPoint
    let endPoint: CGPoint

    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(position: startPoint,
                   velocity: CGVector(dx: 0, dy: 0),
                   force: CGVector(dx: 0, dy: 0),
                   isMoveable: false,
                   elasticity: LinePhysicsObject.DEFAULT_LINE_ELASTICITY)
    }
}
