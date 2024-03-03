/**
 The `Block` class represents a data of a block in the Peggle-like game. It defines the properties and behavior of a
 block.

 ## Invariants:
 - Each block has a unique identifier (`id`).
 - The block must have a valid position. i.e. cannot have negative x or y
 - The block must have a valid size. i.e. height and width must be greater than 0
 - The peg must have a rotation.

 - Note: The `Block` class conforms to the `Equatable` protocol, with equality based on the `id` property.

 - Authors: CS3217, HoJunHao2000
 */
import Foundation

class Block {
    static let DEFAULT_BLOCK_WIDTH: Double = 50
    static let DEFAULT_BLOCK_HEIGHT: Double = 25
    static let DEFAULT_BLOCK_ANGLE: Double = 0

    let id: UUID
    private(set) var position: CGPoint
    private(set) var size: CGSize
    private(set) var rotation: Double

    init(id: UUID,
         position: CGPoint,
         size: CGSize = CGSize(width: Block.DEFAULT_BLOCK_WIDTH, height: Block.DEFAULT_BLOCK_HEIGHT),
         rotation: Double = Block.DEFAULT_BLOCK_ANGLE) {
        self.id = id
        self.size = size
        self.position = position
        self.rotation = rotation

        assert(checkRepresentation())
    }

    var height: Double {
        size.height
    }

    var width: Double {
        size.width
    }

    func setPosition(newPosition: CGPoint) {
        assert(checkRepresentation())

        guard newPosition.x >= 0 && newPosition.y >= 0 else {
            return
        }

        self.position = newPosition

        assert(checkRepresentation())
    }

    func setRotation(newAngle: Double) {
        assert(checkRepresentation())

        self.rotation = newAngle

        assert(checkRepresentation())
    }

    func setHeight(newHeight: Double) {
        assert(checkRepresentation())

        guard newHeight > 0 else {
            return
        }

        self.size.height = newHeight

        assert(checkRepresentation())
    }

    func setWidth(newWidth: Double) {
        assert(checkRepresentation())

        guard newWidth > 0 else {
            return
        }

        self.size.width = newWidth

        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        guard position.x >= 0 && position.y >= 0 && size.width > 0 && size.height > 0 else {
            return false
        }

        return true
    }
}

extension Block: Hashable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
