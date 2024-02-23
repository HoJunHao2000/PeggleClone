//
//  PegCoreDataTranslator.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 23/2/24.
//

import Foundation
import CoreData

class PegCoreDataTranslator {
    func translateToEntity(peg: Peg, context: NSManagedObjectContext) -> PegEntity {
        let entity = PegEntity(context: context)
        entity.id = peg.id
        entity.x = Double(peg.position.x)
        entity.y = Double(peg.position.y)
        entity.pegtype = Int64(peg.pegtype.rawValue)
        return entity
    }

    func translateToModel(pegEntity: PegEntity) -> Peg {
        Peg(id: pegEntity.id ?? UUID(),
            position: CGPoint(x: CGFloat(pegEntity.x), y: CGFloat(pegEntity.y)),
            pegtype: PegType(rawValue: Int(pegEntity.pegtype)) ?? .NormalPeg,
            diameter: pegEntity.diameter,
            rotation: pegEntity.rotation)
    }
}
