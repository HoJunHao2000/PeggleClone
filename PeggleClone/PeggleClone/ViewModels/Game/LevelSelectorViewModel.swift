//
//  LevelSelectorViewModel.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/2/24.
//

import Foundation

class LevelSelectorViewModel: ObservableObject {
    private let coreDataDelegate = GameboardCoreDataDelegate()
    private let gameboardTranslator = GameboardCoreDataTranslator()

    var gameboards: [Gameboard] {
        let gameboardEntities = coreDataDelegate.getGameboards()
        var gameboards: [Gameboard] = []

        for i in 1..<4 {
            let defaultGameboard = Gameboard(id: UUID(), name: "Preloaded \(i)", boardSize: .zero, pegs: [], blocks: [])
            gameboards.append(defaultGameboard)
        }

        for i in 0..<gameboardEntities.count {
            let gameboardModel = gameboardTranslator.translateToModel(entity: gameboardEntities[i])
            gameboards.append(gameboardModel)
        }

        return gameboards
    }
}
