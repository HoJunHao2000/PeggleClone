//
//  GameboardCoreDataDelegate.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 23/2/24.
//

import Foundation
import CoreData

class GameboardCoreDataDelegate {
    let manager = CoreDataManager.instance
    let gameboardTranslator = GameboardCoreDataTranslator()

    func saveGameboard(gameboard: Gameboard) {
        // Delete existing gameboard
        if let existingGameboard = getGameboardEntity(id: gameboard.id) {
            self.manager.context.delete(existingGameboard)
        }

        // Create and save new gameboard
        _ = gameboardTranslator.translateToEntity(gameboard: gameboard, context: self.manager.context)
        self.manager.save()
    }

    func getGameboards() -> [GameboardEntity] {
        let request = NSFetchRequest<GameboardEntity>(entityName: "GameboardEntity")

        do {
            let gameboards = try self.manager.context.fetch(request)
            return gameboards
        } catch {
            print("Error fetching gameboards: \(error)")
            return []
        }
    }

    func deleteGameboard(id: UUID) {
        if let gameboardEntity = getGameboardEntity(id: id) {
            self.manager.context.delete(gameboardEntity)
            self.manager.save()
        }
    }

    /// Fetches all stored gameboards from Core Data.
    /// - Returns: An array of `GameboardEntity` representing all stored gameboards.
    func getGameboard(id: UUID) -> Gameboard? {
        if let gameboardEntity = getGameboardEntity(id: id) {
            let gameboardModel = gameboardTranslator.translateToModel(entity: gameboardEntity)
            return gameboardModel
        }

        return nil
    }

    /// Fetches a specific gameboard entity from Core Data based on its unique identifier.
    /// - Parameter id: The unique identifier of the gameboard entity.
    /// - Returns: The `GameboardEntity` corresponding to the specified identifier, or `nil` if not found.
    private func getGameboardEntity(id: UUID) -> GameboardEntity? {
        let request = NSFetchRequest<GameboardEntity>(entityName: "GameboardEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let result = try self.manager.context.fetch(request)
            return result.first
        } catch {
            print("Error fetching gameboard: \(error)")
            return nil
        }
    }
}
