//
//  BlockGameObject.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 26/2/24.
//

import Foundation

class BlockGameObject {
    static let DEFAULT_BLOCK_ELASTICITY: Double = 0.95

    private(set) var physicsObject: RectPhysicsObject

    init(block: Block) {
        self.physicsObject = RectPhysicsObject(position: block.position,
                                               size: block.size,
                                               elasticity: BlockGameObject.DEFAULT_BLOCK_ELASTICITY,
                                               rotation: block.rotation)
    }

    var height: Double {
        physicsObject.size.height
    }

    var width: Double {
        physicsObject.size.width
    }

    var rotation: Double {
        physicsObject.rotation
    }

    var position: CGPoint {
        physicsObject.position
    }
}

extension BlockGameObject: Hashable {
    static func == (lhs: BlockGameObject, rhs: BlockGameObject) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
