/**
 The `LevelDesignerViewModel` class serves as a ViewModel, bridging the interaction between the
 gameboard model and views in a Peggle-like game. It manages the creation, editing, loading, and
 saving of gameboards. Additionally, it provides functionality for manipulating the gameboard's state,
 such as adding or deleting pegs, changing peg colors, and resetting the gameboard.

 ## Purpose of `LevelDesignerViewModel`:
 - ViewModel for Peggle-like game
 - Connects gameboard model with views
 - Handles user interactions and updates associated views

 ## Representation Invariants for Every `LevelDesignerViewModel`:
 - There must always be a valid Gameboard
 - coreDataDelegate must be a boolean
 - validator must exist

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class LevelDesignerViewModel: ObservableObject {
    private(set) var gameboard: Gameboard
    private(set) var pegtype: PegType
    private(set) var isDelete: Bool
    private(set) var selectedPeg: Peg?
    private(set) var diameter: Double?
    private(set) var rotation: Double?

    private let coreDataDelegate = GameboardCoreDataDelegate()
    private let validator = LevelDesignerValidatorDelegate()

    init() {
        self.gameboard = Gameboard(id: UUID(), name: "", boardSize: .zero, pegs: [])
        self.pegtype = .NormalPeg
        self.isDelete = false
    }

    var gameboards: [GameboardEntity] {
        coreDataDelegate.getGameboards()
    }

    /// Loads a gameboard with the specified identifier.
    /// - Parameter id: The unique identifier of the gameboard to be loaded.
    func loadGameboard(id: UUID) {
        if let loadedGamboard = coreDataDelegate.getGameboard(id: id) {
            self.gameboard = loadedGamboard
            objectWillChange.send()
        }
    }

    /// Creates a new empty gameboard.
    func newGameboard() {
        let oldBoardSize = self.gameboard.boardSize
        self.gameboard = Gameboard(id: UUID(), name: "", boardSize: oldBoardSize, pegs: [])
        objectWillChange.send()
    }

    /// Saves the current gameboard to Core Data.
    /// - Parameter name: The name to be associated with the gameboard.
    func saveGameboard(name: String) {
        self.gameboard.setName(newName: name)
        coreDataDelegate.saveGameboard(gameboard: gameboard)
        objectWillChange.send()
    }

    /// Deletes the currently loaded gameboard.
    func deleteGameboard() {
        coreDataDelegate.deleteGameboard(id: self.gameboard.id)
        newGameboard()
        objectWillChange.send()
    }

    func setBoardSize(newSize: CGSize) {
        guard validator.arePegsWithinBoard(boardSize: newSize, pegs: gameboard.pegs) else {
            return
        }
        self.gameboard.setBoardSize(newSize: newSize)
        objectWillChange.send()
    }

    func setPegType(pegtype: PegType) {
        self.pegtype = pegtype
        objectWillChange.send()
    }

    func toggleIsDelete() {
        self.isDelete.toggle()
        objectWillChange.send()
    }

    func addPeg(at location: CGPoint) {
        let newPeg = Peg(id: UUID(), position: location, pegtype: pegtype)

        guard validator.isValidLocation(newPeg: newPeg, boardSize: gameboard.boardSize, pegs: gameboard.pegs) else {
            return
        }

        self.gameboard.addPeg(peg: newPeg)
        objectWillChange.send()
    }

    func deletePeg(peg: Peg) {
        self.gameboard.deletePeg(peg: peg)
        objectWillChange.send()
    }

    func movePeg(peg: Peg, to location: CGPoint) {
        guard validator.isValidLocation(point: location, peg: peg, gameboard: gameboard) else {
            return
        }

        self.gameboard.movePeg(peg: peg, to: location)
        objectWillChange.send()
    }

    func selectedPeg(peg: Peg) {
        self.selectedPeg = peg
        self.diameter = peg.diameter
        self.rotation = peg.rotation

        objectWillChange.send()
    }

    func resizePeg(newDiameter: Double) {
        if let selectedPeg = selectedPeg {
            guard validator.isValidSize(peg: selectedPeg, diameter: newDiameter, gameboard: gameboard) else {
                return
            }
            gameboard.resizePeg(peg: selectedPeg, newDiameter: newDiameter)
            objectWillChange.send()
        }
    }

    func rotatePeg(newAngle: Double) {
        if let selectedPeg = selectedPeg {
            gameboard.rotatePeg(peg: selectedPeg, newAngle: newAngle)
            objectWillChange.send()
        }
    }

    func reset() {
        self.gameboard.reset()
        objectWillChange.send()
    }
}
