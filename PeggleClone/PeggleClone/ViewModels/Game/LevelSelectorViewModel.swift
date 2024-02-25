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
        return gameboardEntities.map { gameboardTranslator.translateToModel(entity: $0) }
    }
}
