//
//  BucketGameObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 27/2/24.
//

import Foundation

class BucketGameObject {
    private static let DEFAULT_BUCKET_ELASTICITY: Double = 0.95
    private static let DEFAULT_BUCKET_HEIGHT: Double = 100
    private static let DEFAULT_BUCKET_WIDTH: Double = 100

    private(set) var physicsObject: RectPhysicsObject

    init(boardSize: CGSize) {
        let position = CGPoint(x: 50, y: boardSize.height - 50)
        let bucketSize = CGSize(width: BucketGameObject.DEFAULT_BUCKET_WIDTH,
                                height: BucketGameObject.DEFAULT_BUCKET_HEIGHT)
        self.physicsObject = RectPhysicsObject(position: position,
                                               size: bucketSize,
                                               elasticity: BucketGameObject.DEFAULT_BUCKET_ELASTICITY,
                                               velocity: CGVector(dx: 100, dy: 0),
                                               isMoveable: true)
    }

    var height: Double {
        physicsObject.size.height
    }

    var width: Double {
        physicsObject.size.width
    }

    var isBallEnter: Bool {
        physicsObject.hitCount > 0
    }

    var position: CGPoint {
        physicsObject.position
    }
}
