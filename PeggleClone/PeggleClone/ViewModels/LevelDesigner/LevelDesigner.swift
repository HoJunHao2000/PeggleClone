/**
 The `LevelDesigner` class serves as a ViewModel, bridging the interaction between the
 gameboard model and views in a Peggle-like game. It manages the creation, editing, loading, and
 saving of gameboards. Additionally, it provides functionality for manipulating the gameboard's state,
 such as adding or deleting pegs, changing peg colors, and resetting the gameboard.

 ## Purpose of `LevelDesigner`:
 - ViewModel for Peggle-like game
 - Connects gameboard model with views
 - Handles user interactions and updates associated views

 ## Representation Invariants for Every `LevelDesigner`:
 - There must always be a valid Gameboard
 - isBlue must be a boolean
 - isDelete must be a boolean
 - CoreDataManager must exist

 - Authors: CS3217, HoJunHao2000
 */

import Foundation
import CoreData

class LevelDesigner: ObservableObject {
    @Published private(set) var gameboard: Gameboard
    @Published private(set) var isBlue: Bool
    @Published private(set) var isDelete: Bool

    private let manager = CoreDataManager.instance

    init() {
        self.gameboard = Gameboard(id: UUID(), name: "", boardSize: .zero, pegs: [])
        self.isBlue = false
        self.isDelete = false
    }

    /// Loads a gameboard with the specified identifier.
    /// - Parameter id: The unique identifier of the gameboard to be loaded.
    func loadGameboard(id: UUID) {
        if let loadedGameboard = getGameboard(id: id) {
            self.gameboard = loadedGameboard
        }
    }

    /// Creates a new empty gameboard.
    func newGameboard() {
        let oldBoardSize = self.gameboard.boardSize
        self.gameboard = Gameboard(id: UUID(), name: "", boardSize: oldBoardSize, pegs: [])
    }

    /// Fetches all stored gameboards from Core Data.
    /// - Returns: An array of `GameboardEntity` representing all stored gameboards.
    private func getGameboard(id: UUID) -> Gameboard? {
        if let gameboardEntity = getGameboardEntity(id: id) {
            var pegs: [Peg] = []
            if let pegEntities = gameboardEntity.pegs?.allObjects as? [PegEntity] {
                for pegEntity in pegEntities {
                    if let pegId = pegEntity.id {
                        let peg = Peg(id: pegId,
                                      position: CGPoint(x: CGFloat(pegEntity.x), y: CGFloat(pegEntity.y)),
                                      isBlue: pegEntity.isBlue)
                        pegs.append(peg)
                    }
                }
            }

            if let gameboardId = gameboardEntity.id,
               let gameboardName = gameboardEntity.name {

                return Gameboard(id: gameboardId,
                                 name: gameboardName,
                                 boardSize: CGSize(width: CGFloat(gameboardEntity.width),
                                                   height: CGFloat(gameboardEntity.height)),
                                 pegs: pegs)
            }
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

    /// Saves the current gameboard to Core Data.
    /// - Parameter name: The name to be associated with the gameboard.
    func saveGameboard(name: String) {
        let existingGameboard = getGameboardEntity(id: self.gameboard.id)

        if let existingGameboard = existingGameboard {
            // Delete existing gameboard
            self.manager.context.delete(existingGameboard)
        }

        self.gameboard.setName(newName: name)

        // Create new gameboard
        let newGameboardEntity = GameboardEntity(context: self.manager.context)
        newGameboardEntity.id = self.gameboard.id
        newGameboardEntity.name = name
        newGameboardEntity.height = Float(self.gameboard.boardSize.height)
        newGameboardEntity.width = Float(self.gameboard.boardSize.width)

        self.gameboard.pegs.forEach { peg in
            let newPegEntity = PegEntity(context: self.manager.context)
            newPegEntity.id = peg.id
            newPegEntity.x = Float(peg.position.x)
            newPegEntity.y = Float(peg.position.y)
            newPegEntity.isBlue = peg.isBlue
            newGameboardEntity.addToPegs(newPegEntity)
        }

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

    /// Deletes the currently loaded gameboard.
    func deleteGameboard() {
        if let gameboardEntity = getGameboardEntity(id: gameboard.id) {
            self.manager.context.delete(gameboardEntity)
            self.manager.save()
            newGameboard()
        }
    }

    func setBoardSize(newSize: CGSize) {
        self.gameboard.setBoardSize(newSize: newSize)
    }

    func setIsBlue(isBlue: Bool) {
        self.isBlue = isBlue
    }

    func toggleIsDelete() {
        self.isDelete.toggle()
    }

    func addPeg(at location: CGPoint) {
        self.gameboard.addPeg(at: location, isBlue: isBlue)
    }

    func deletePeg(at index: Int) {
        self.gameboard.deletePeg(index: index)
    }

    func movePeg(at index: Int, to location: CGPoint) {
        self.gameboard.movePeg(at: index, to: location)
    }

    func reset() {
        self.gameboard.reset()
    }
}
