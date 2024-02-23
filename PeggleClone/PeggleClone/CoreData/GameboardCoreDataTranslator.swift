//
//  GameboardCoreDataTranslator.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 23/2/24.
//

import Foundation
import CoreData

class GameboardCoreDataTranslator {
    let pegTranslator = PegCoreDataTranslator()

    func translateToEntity(gameboard: Gameboard, context: NSManagedObjectContext) -> GameboardEntity {
        let entity = GameboardEntity(context: context)
        entity.id = gameboard.id
        entity.name = gameboard.name
        entity.width = Double(gameboard.boardSize.width)
        entity.height = Double(gameboard.boardSize.height)

        let pegEntities = gameboard.pegs.map { peg in
            pegTranslator.translateToEntity(peg: peg, context: context)
        }
        entity.addToPegs(NSSet(array: pegEntities))

        return entity
    }

    func translateToModel(entity: GameboardEntity) -> Gameboard {
        var pegs: [Peg] = []
        if let pegEntities = entity.pegs?.allObjects as? [PegEntity] {
            for pegEntity in pegEntities {
                let peg = pegTranslator.translateToModel(pegEntity: pegEntity)
                pegs.append(peg)
            }
        }

        return Gameboard(id: entity.id ?? UUID(),
                         name: entity.name ?? "",
                         boardSize: CGSize(width: CGFloat(entity.width),
                                           height: CGFloat(entity.height)),
                         pegs: pegs)
    }
}
