//
//  LevelDesignerViewModelTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/2/24.
//

import XCTest
@testable import PeggleClone

final class LevelDesignerViewModelTestsOne: XCTestCase {
    func testInitialization() {
        let levelDesigner = LevelDesignerViewModel()

        XCTAssertNotNil(levelDesigner, "LevelDesigner should be initialized")
        XCTAssertNotNil(levelDesigner.gameboard, "Gameboard should be initialized")
        XCTAssertEqual(levelDesigner.pegtype, PegType.NormalPeg, "Pegtype should be normal")
        XCTAssertFalse(levelDesigner.isDelete, "isDelete should be false")
        XCTAssertNil(levelDesigner.selectedPeg, "selectedPeg should be nil")
        XCTAssertNil(levelDesigner.selectedBlock, "selectedBlock should be nil")
        XCTAssertNil(levelDesigner.diameter, "diameter should be nil")
        XCTAssertNil(levelDesigner.rotation, "rotation should be nil")
        XCTAssertNil(levelDesigner.height, "height should be nil")
        XCTAssertNil(levelDesigner.width, "width should be nil")
        XCTAssertEqual(levelDesigner.pegsCountByType, [:], "pegsCountByType should be empty")
    }

    func testSetPegType() {
        let levelDesigner = LevelDesignerViewModel()
        let pegtype = PegType.NormalPeg

        levelDesigner.setPegType(pegtype: pegtype)
        XCTAssertEqual(levelDesigner.pegtype, pegtype, "Failed to set pegtype")

        levelDesigner.setPegType(pegtype: nil)
        XCTAssertNil(levelDesigner.pegtype, "Failed to set pegtype to nil")
    }

    func testToggleDelete() {
        let levelDesigner = LevelDesignerViewModel()

        levelDesigner.toggleIsDelete()
        XCTAssertTrue(levelDesigner.isDelete, "Failed to toggle isDelete to true")

        levelDesigner.toggleIsDelete()
        XCTAssertFalse(levelDesigner.isDelete, "Failed to toggle isDelete to false")
    }

    // Mark - Gameboard manipulation
    func testSetBoardSize() {
        let levelDesigner = LevelDesignerViewModel()

        let size = CGSize(width: 100, height: 200)
        levelDesigner.setBoardSize(newSize: size)
        XCTAssertEqual(levelDesigner.gameboard.boardSize, size, "Failed to set board size")

        let newSize = CGSize(width: 200, height: 300)
        levelDesigner.setBoardSize(newSize: newSize)
        XCTAssertEqual(levelDesigner.gameboard.boardSize, newSize, "Failed to set board size")

        let invalidSize = CGSize(width: -100, height: 300)
        levelDesigner.setBoardSize(newSize: invalidSize)
        XCTAssertEqual(levelDesigner.gameboard.boardSize, newSize, "Should not set board size due to invalid input")
    }

    func testAddPegsToGameboard() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        levelDesigner.addPeg(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(levelDesigner.gameboard.pegs.count, 1, "Failed to add peg to gameboard")

        levelDesigner.addPeg(at: CGPoint(x: 200, y: 200))
        XCTAssertEqual(levelDesigner.gameboard.pegs.count, 2, "Failed to add peg to gameboard")

        levelDesigner.addPeg(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(levelDesigner.gameboard.pegs.count,
                       2,
                       "Should not add peg to gameboard due to overlapping with existing peg")

        levelDesigner.addPeg(at: CGPoint(x: 1_000, y: 1_000))
        XCTAssertEqual(levelDesigner.gameboard.pegs.count,
                       2,
                       "Should not add peg to gameboard due to invalid location")

        levelDesigner.setPegType(pegtype: nil)
        levelDesigner.addBlock(at: CGPoint(x: 310, y: 310))
        levelDesigner.setPegType(pegtype: .NormalPeg)
        levelDesigner.addPeg(at: CGPoint(x: 300, y: 300))
        XCTAssertEqual(levelDesigner.gameboard.pegs.count,
                       2,
                       "Should not add peg to gameboard due to overlapping with existing block")

        levelDesigner.addPeg(at: CGPoint(x: 100, y: 410))
        XCTAssertEqual(levelDesigner.gameboard.pegs.count,
                       2,
                       "Should not add peg to gameboard due to invalid location in bucket region")
    }

    func testAddBlockToGameboard() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))
        levelDesigner.setPegType(pegtype: nil)

        levelDesigner.addBlock(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(levelDesigner.gameboard.blocks.count, 1, "Failed to add block to gameboard")

        levelDesigner.addBlock(at: CGPoint(x: 200, y: 200))
        XCTAssertEqual(levelDesigner.gameboard.blocks.count, 2, "Failed to add block to gameboard")

        levelDesigner.addBlock(at: CGPoint(x: 100, y: 100))
        XCTAssertEqual(levelDesigner.gameboard.blocks.count,
                       2,
                       "Should not add block to gameboard due to overlapping with existing block")

        levelDesigner.addBlock(at: CGPoint(x: 1_000, y: 1_000))
        XCTAssertEqual(levelDesigner.gameboard.blocks.count,
                       2,
                       "Should not add block to gameboard due to invalid location")

        levelDesigner.setPegType(pegtype: .NormalPeg)
        levelDesigner.addPeg(at: CGPoint(x: 300, y: 300))
        levelDesigner.setPegType(pegtype: nil)
        levelDesigner.addBlock(at: CGPoint(x: 300, y: 300))
        XCTAssertEqual(levelDesigner.gameboard.blocks.count,
                       2,
                       "Should not add block to gameboard due to overlapping with existing peg")

        levelDesigner.addBlock(at: CGPoint(x: 100, y: 410))
        XCTAssertEqual(levelDesigner.gameboard.blocks.count,
                       2,
                       "Should not add block to gameboard due to invalid location in bucket region")
    }

    func testDeletePeg() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let peg1 = Peg(id: UUID(), position: CGPoint(x: 100, y: 100), pegtype: .NormalPeg)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 200, y: 200), pegtype: .GoalPeg)
        levelDesigner.gameboard.addPeg(peg: peg1)
        levelDesigner.gameboard.addPeg(peg: peg2)

        levelDesigner.setPegType(pegtype: nil)
        levelDesigner.addBlock(at: CGPoint(x: 100, y: 100))
        levelDesigner.addBlock(at: CGPoint(x: 200, y: 200))

        levelDesigner.deletePeg(peg: peg1)
        XCTAssertEqual(levelDesigner.gameboard.pegs.count, 1, "Failed to delete peg from gameboard")
        XCTAssertEqual(levelDesigner.gameboard.pegs[0], peg2, "Failed to delete correct peg from gameboard")

        levelDesigner.deletePeg(peg: peg2)
        XCTAssertEqual(levelDesigner.gameboard.pegs.count, 0, "Failed to delete peg from gameboard")

        // check delete selected peg
        levelDesigner.gameboard.addPeg(peg: peg1)
        levelDesigner.setSelectedPeg(peg: peg1)
        XCTAssertEqual(levelDesigner.selectedPeg, peg1, "Failed to select peg")
        levelDesigner.deletePeg(peg: peg1)
        XCTAssertNil(levelDesigner.selectedPeg, "Failed to deselect peg")

        // delete non-existing peg
        levelDesigner.deletePeg(peg: peg1)
        XCTAssertEqual(levelDesigner.gameboard.pegs.count, 0, "Should not delete non-existing peg")
    }

    func testDeleteBlock() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let block1 = Block(id: UUID(), position: CGPoint(x: 100, y: 100))
        let block2 = Block(id: UUID(), position: CGPoint(x: 200, y: 200))
        levelDesigner.gameboard.addBlock(block: block1)
        levelDesigner.gameboard.addBlock(block: block2)

        levelDesigner.deleteBlock(block: block1)
        XCTAssertEqual(levelDesigner.gameboard.blocks.count, 1, "Failed to delete block from gameboard")
        XCTAssertEqual(levelDesigner.gameboard.blocks[0], block2, "Failed to delete correct block from gameboard")

        levelDesigner.deleteBlock(block: block2)
        XCTAssertEqual(levelDesigner.gameboard.blocks.count, 0, "Failed to delete block from gameboard")

        // check delete selected block
        levelDesigner.gameboard.addBlock(block: block1)
        levelDesigner.setSelectedBlock(block: block1)
        XCTAssertEqual(levelDesigner.selectedBlock, block1, "Failed to select block")
        levelDesigner.deleteBlock(block: block1)
        XCTAssertNil(levelDesigner.selectedBlock, "Failed to deselect block")

        // delete non-existing block
        levelDesigner.deleteBlock(block: block1)
        XCTAssertEqual(levelDesigner.gameboard.blocks.count, 0, "Should not delete non-existing block")
    }

    func testMovePeg() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        levelDesigner.addPeg(at: CGPoint(x: 100, y: 100))
        levelDesigner.addPeg(at: CGPoint(x: 200, y: 200))
        levelDesigner.setPegType(pegtype: nil)
        levelDesigner.addBlock(at: CGPoint(x: 300, y: 300))

        levelDesigner.movePeg(peg: levelDesigner.gameboard.pegs[0], to: CGPoint(x: 110, y: 110))

        XCTAssertEqual(levelDesigner.gameboard.pegs[0].position, CGPoint(x: 110, y: 110), "Failed to move peg")

        levelDesigner.movePeg(peg: levelDesigner.gameboard.pegs[0], to: CGPoint(x: 300, y: 300))
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move peg due to overlapping with block")

        levelDesigner.movePeg(peg: levelDesigner.gameboard.pegs[0], to: CGPoint(x: 1_000, y: 1_000))
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move peg due to invalid location")

        levelDesigner.movePeg(peg: levelDesigner.gameboard.pegs[0], to: CGPoint(x: 100, y: 410))
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move peg due to invalid location in bucket region")

        levelDesigner.movePeg(peg: levelDesigner.gameboard.pegs[0], to: CGPoint(x: 200, y: 200))
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move peg due to overlapping with another peg")
    }

    func testMoveBlock() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        levelDesigner.setPegType(pegtype: nil)
        levelDesigner.addBlock(at: CGPoint(x: 100, y: 100))
        levelDesigner.addBlock(at: CGPoint(x: 200, y: 200))
        levelDesigner.setPegType(pegtype: .NormalPeg)
        levelDesigner.addPeg(at: CGPoint(x: 300, y: 300))

        levelDesigner.moveBlock(block: levelDesigner.gameboard.blocks[0], to: CGPoint(x: 110, y: 110))
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].position, CGPoint(x: 110, y: 110), "Failed to move block")

        levelDesigner.moveBlock(block: levelDesigner.gameboard.blocks[0], to: CGPoint(x: 300, y: 300))
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move block due to overlapping with peg")

        levelDesigner.moveBlock(block: levelDesigner.gameboard.blocks[0], to: CGPoint(x: 1_000, y: 1_000))
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move block due to invalid location")

        levelDesigner.moveBlock(block: levelDesigner.gameboard.blocks[0], to: CGPoint(x: 100, y: 410))
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move block due to invalid location in bucket region")

        levelDesigner.moveBlock(block: levelDesigner.gameboard.blocks[0], to: CGPoint(x: 200, y: 200))
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].position,
                       CGPoint(x: 110, y: 110),
                       "Should not move block due to overlapping with another block")
    }
}
