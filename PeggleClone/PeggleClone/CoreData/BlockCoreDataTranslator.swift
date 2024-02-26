//
//  BlockCoreDataTranslator.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 26/2/24.
//

import Foundation
import CoreData

class BlockCoreDataTranslator {
    func translateToEntity(block: Block, context: NSManagedObjectContext) -> BlockEntity {
        let entity = BlockEntity(context: context)
        entity.id = block.id
        entity.x = Double(block.position.x)
        entity.y = Double(block.position.y)
        entity.height = Double(block.size.height)
        entity.width = Double(block.size.width)
        entity.rotation = block.rotation
        return entity
    }

    func translateToModel(blockEntity: BlockEntity) -> Block {
        Block(id: blockEntity.id ?? UUID(),
              position: CGPoint(x: CGFloat(blockEntity.x), y: CGFloat(blockEntity.y)),
              size: CGSize(width: CGFloat(blockEntity.width), height: CGFloat(blockEntity.height)),
              rotation: blockEntity.rotation)
    }
}
