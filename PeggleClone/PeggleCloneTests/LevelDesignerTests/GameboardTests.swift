//
//  GameboardTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/2/24.
//

import XCTest
@testable import PeggleClone

final class GameboardTests: XCTestCase {
    func testInit() {
        let id = UUID()
        let name = "TestBoard"
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: id, name: name, boardSize: boardSize, pegs: pegs, blocks: blocks)

        XCTAssertNotNil(gameboard, "Gameboard should be initialized")
        XCTAssertEqual(gameboard.id, id, "Incorrect ID")
        XCTAssertEqual(gameboard.name, name, "Incorrect name")
        XCTAssertEqual(gameboard.boardSize, boardSize, "Incorrect board size")
        XCTAssertEqual(gameboard.pegs.count, pegs.count, "Incorrect number of pegs")
        XCTAssertEqual(gameboard.blocks.count, blocks.count, "Incorrect number of blocks")
        XCTAssertEqual(gameboard.pegs[0].position, pegs[0].position, "Incorrect position for peg 0")
        XCTAssertEqual(gameboard.pegs[0].pegtype, pegs[0].pegtype, "Incorrect peg type for peg 0")
        XCTAssertEqual(gameboard.blocks[0].position, blocks[0].position, "Incorrect position for block 0")
        XCTAssertEqual(gameboard.blocks[0].size, blocks[0].size, "Incorrect size for block 0")
        XCTAssertEqual(gameboard.blocks[0].rotation, blocks[0].rotation, "Incorrect rotation for block 0")
    }

    func testSetName() {
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: CGSize(width: 50, height: 50), pegs: [], blocks: [])

        gameboard.setName(newName: "NewName")

        XCTAssertEqual(gameboard.name, "NewName", "Failed to set the name")
    }

    func testSetBoardSize() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs: [Peg] = []
        let blocks: [Block] = []
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.setBoardSize(newSize: CGSize(width: 600, height: 600))
        XCTAssertEqual(gameboard.boardSize, CGSize(width: 600, height: 600), "Failed to change board size")
    }

    func testAddPeg() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        let newPeg1 = Peg(id: UUID(), position: CGPoint(x: 150, y: 50), pegtype: .NormalPeg)
        gameboard.addPeg(peg: newPeg1)

        XCTAssertEqual(gameboard.pegs.count, 3, "Failed to add a peg")
        XCTAssertEqual(gameboard.pegs[2].position, newPeg1.position, "Incorrect position for the new peg")
        XCTAssertEqual(gameboard.pegs[2].pegtype, newPeg1.pegtype, "Incorrect peg type for the new peg")
    }

    func testAddBlock() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        let newBlock1 = Block(id: UUID(),
                              position: CGPoint(x: 350, y: 250),
                              size: CGSize(width: 50, height: 50),
                              rotation: 0.0)
        gameboard.addBlock(block: newBlock1)

        XCTAssertEqual(gameboard.blocks.count, 3, "Failed to add a block")
        XCTAssertEqual(gameboard.blocks[2].position, newBlock1.position, "Incorrect position for the new block")
        XCTAssertEqual(gameboard.blocks[2].size, newBlock1.size, "Incorrect size for the new block")
        XCTAssertEqual(gameboard.blocks[2].rotation, newBlock1.rotation, "Incorrect rotation for the new block")
    }

    func testDeletePeg() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        // Test deleting a peg
        gameboard.deletePeg(peg: pegs[0])

        XCTAssertEqual(gameboard.pegs.count, 1, "Failed to delete a peg")
        XCTAssertEqual(gameboard.pegs[0].position, pegs[1].position, "Incorrect peg deleted")
    }

    func testDeleteBlock() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.deleteBlock(block: blocks[0])

        XCTAssertEqual(gameboard.blocks.count, 1, "Failed to delete a block")
        XCTAssertEqual(gameboard.blocks[0].position, blocks[1].position, "Incorrect block deleted")
    }

    func testMovePeg() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
       let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.movePeg(peg: pegs[0], to: CGPoint(x: 150, y: 50))
        XCTAssertEqual(gameboard.pegs[0].position, CGPoint(x: 150, y: 50), "Failed to move a peg")
    }

    func testMoveBlock() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.moveBlock(block: blocks[0], to: CGPoint(x: 250, y: 350))

        XCTAssertEqual(gameboard.blocks[0].position, CGPoint(x: 250, y: 350), "Failed to move a block")
    }

    func testResizePeg() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.resizePeg(peg: pegs[0], newDiameter: 20)

        XCTAssertEqual(gameboard.pegs[0].diameter, 20, "Failed to resize a peg")
    }

    func testResizeBlockHeight() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.resizeBlockHeight(block: blocks[0], newHeight: 100)

        XCTAssertEqual(gameboard.blocks[0].size.height, 100, "Failed to resize a block's height")
    }

    func testResizeBlockWidth() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.resizeBlockWidth(block: blocks[0], newWidth: 100)

        XCTAssertEqual(gameboard.blocks[0].size.width, 100, "Failed to resize a block's width")
    }

    func testRotatePeg() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.rotatePeg(peg: pegs[0], newAngle: 90)

        XCTAssertEqual(gameboard.pegs[0].rotation, 90, "Failed to rotate a peg")
    }

    func testRotateBlock() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.rotateBlock(block: blocks[0], newAngle: 90)

        XCTAssertEqual(gameboard.blocks[0].rotation, 90, "Failed to rotate a block")
    }

    func testReset() {
        let boardSize = CGSize(width: 500, height: 500)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 50, y: 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 150), pegtype: .NormalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)

        gameboard.reset()

        XCTAssertEqual(gameboard.pegs.count, 0, "Failed to reset pegs")
        XCTAssertEqual(gameboard.blocks.count, 0, "Failed to reset blocks")
    }
}
