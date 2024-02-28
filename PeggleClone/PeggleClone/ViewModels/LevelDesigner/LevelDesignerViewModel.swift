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
    private(set) var pegtype: PegType?
    private(set) var isDelete: Bool
    private(set) var selectedPeg: Peg?
    private(set) var selectedBlock: Block?
    private(set) var diameter: Double?
    private(set) var rotation: Double?
    private(set) var height: Double?
    private(set) var width: Double?
    private(set) var pegsCountByType: [PegType: Int] = [:]

    private let coreDataDelegate = GameboardCoreDataDelegate()
    private let validator = LevelDesignerValidatorDelegate()
    private let preloader = PreloaderDelegate()

    init() {
        self.gameboard = Gameboard(id: UUID(), name: "", boardSize: .zero, pegs: [], blocks: [])
        self.pegtype = .NormalPeg
        self.isDelete = false
    }

    var gameboards: [GameboardEntity] {
        coreDataDelegate.getGameboards()
    }

    var hasMinOneGoalPeg: Bool {
        gameboard.pegs.contains(where: { $0.pegtype == .GoalPeg })
    }

    /// Loads a gameboard with the specified identifier.
    /// - Parameter id: The unique identifier of the gameboard to be loaded.
    func loadGameboard(id: UUID, preloadId: Int) {
        var loadedGameboard: Gameboard?

        if preloadId != -1 {
            loadedGameboard = preloader.load(id: preloadId, gameboard: gameboard)
        } else {
            loadedGameboard = coreDataDelegate.getGameboard(id: id)
        }

        if let loadedGameboard = loadedGameboard {
            self.gameboard = loadedGameboard
            self.pegsCountByType = [:]

            for peg in loadedGameboard.pegs {
                pegsCountByType[peg.pegtype, default: 0] += 1
            }

            objectWillChange.send()
        }
    }

    /// Creates a new empty gameboard.
    func newGameboard() {
        let oldBoardSize = self.gameboard.boardSize
        self.gameboard = Gameboard(id: UUID(), name: "", boardSize: oldBoardSize, pegs: [], blocks: [])
        self.pegsCountByType = [:]
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
        guard validator.arePegsAndBlocksWithinBoard(boardSize: newSize, gameboard: gameboard) else {
            return
        }

        self.gameboard.setBoardSize(newSize: newSize)
        objectWillChange.send()
    }

    func setPegType(pegtype: PegType?) {
        self.pegtype = pegtype
        objectWillChange.send()
    }

    func toggleIsDelete() {
        self.isDelete.toggle()
        objectWillChange.send()
    }

    func addPeg(at location: CGPoint) {
        guard let pegtype = pegtype else {
            return
        }

        let newPeg = Peg(id: UUID(), position: location, pegtype: pegtype)

        guard validator.isValidLocation(newPeg: newPeg, gameboard: gameboard) else {
            return
        }

        gameboard.addPeg(peg: newPeg)
        pegsCountByType[newPeg.pegtype, default: 0] += 1

        objectWillChange.send()
    }

    func addBlock(at location: CGPoint) {
        guard pegtype == nil else {
            return
        }

        let newBlock = Block(id: UUID(), position: location)

        guard validator.isValidLocation(newBlock: newBlock, gameboard: gameboard) else {
            return
        }

        gameboard.addBlock(block: newBlock)

        objectWillChange.send()
    }

    func deletePeg(peg: Peg) {
        if peg == selectedPeg {
            selectedPeg = nil
            selectedBlock = nil
            diameter = nil
            rotation = nil
            height = nil
            width = nil
        }

        self.gameboard.deletePeg(peg: peg)

        pegsCountByType[peg.pegtype, default: 0] -= 1

        objectWillChange.send()
    }

    func deleteBlock(block: Block) {
        if block == selectedBlock {
            selectedPeg = nil
            selectedBlock = nil
            diameter = nil
            rotation = nil
            height = nil
            width = nil
        }

        self.gameboard.deleteBlock(block: block)

        objectWillChange.send()
    }

    func movePeg(peg: Peg, to location: CGPoint) {
        guard validator.isValidLocation(point: location, peg: peg, gameboard: gameboard) else {
            return
        }

        self.gameboard.movePeg(peg: peg, to: location)
        objectWillChange.send()
    }

    func moveBlock(block: Block, to location: CGPoint) {
        guard validator.isValidLocation(point: location, block: block, gameboard: gameboard) else {
            return
        }

        self.gameboard.moveBlock(block: block, to: location)
        objectWillChange.send()
    }

    func setSelectedPeg(peg: Peg?) {
        self.selectedBlock = nil
        self.selectedPeg = peg
        self.diameter = peg?.diameter
        self.rotation = peg?.rotation
        objectWillChange.send()
    }

    func setSelectedBlock(block: Block?) {
        self.selectedPeg = nil
        self.selectedBlock = block
        self.height = Double(block?.height ?? 50)
        self.width = Double(block?.width ?? 25)
        self.rotation = block?.rotation
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

    func resizeBlockHeight(newHeight: Double) {
        if let selectedBlock = selectedBlock {
            guard validator.isValidBlockHeight(block: selectedBlock, newHeight: newHeight, gameboard: gameboard) else {
                return
            }
            gameboard.resizeBlockHeight(block: selectedBlock, newHeight: newHeight)
            objectWillChange.send()
        }
    }

    func resizeBlockWidth(newWidth: Double) {
        if let selectedBlock = selectedBlock {
            guard validator.isValidBlockWidth(block: selectedBlock, newWidth: newWidth, gameboard: gameboard) else {
                return
            }
            gameboard.resizeBlockWidth(block: selectedBlock, newWidth: newWidth)
            objectWillChange.send()
        }
    }

    func rotatePeg(newAngle: Double) {
        if let selectedPeg = selectedPeg {
            gameboard.rotatePeg(peg: selectedPeg, newAngle: newAngle)
            objectWillChange.send()
        }
    }

    func rotateBlock(newAngle: Double) {
        if let selectedBlock = selectedBlock {
            guard validator.isValidBlockRotation(block: selectedBlock,
                                                 newRotation: newAngle,
                                                 gameboard: gameboard) else {
                return
            }
            gameboard.rotateBlock(block: selectedBlock, newAngle: newAngle)
            objectWillChange.send()
        }
    }

    func reset() {
        self.gameboard.reset()
        self.pegsCountByType = [:]
        self.selectedPeg = nil
        self.selectedBlock = nil
        self.rotation = nil
        self.diameter = nil
        self.height = nil
        self.width = nil
        objectWillChange.send()
    }
}
