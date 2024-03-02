//
//  LevelDesignerViewModelTestsTwo.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/2/24.
//

import XCTest
@testable import PeggleClone

final class LevelDesignerViewModelTestsTwo: XCTestCase {
    func testSetSelectedPeg() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let peg1 = Peg(id: UUID(), position: CGPoint(x: 100, y: 100), pegtype: .NormalPeg)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 200, y: 200), pegtype: .GoalPeg)
        levelDesigner.gameboard.addPeg(peg: peg1)
        levelDesigner.gameboard.addPeg(peg: peg2)

        levelDesigner.setSelectedPeg(peg: peg1)
        XCTAssertNil(levelDesigner.selectedBlock, "Failed to set selectedBlock to nil")
        XCTAssertEqual(levelDesigner.selectedPeg, peg1, "Failed to set selectedPeg")
        XCTAssertEqual(levelDesigner.diameter, peg1.diameter, "Failed to set diameter")
        XCTAssertEqual(levelDesigner.rotation, peg1.rotation, "Failed to set rotation")
        XCTAssertNil(levelDesigner.height, "Failed to set height")
        XCTAssertNil(levelDesigner.width, "Failed to set width")

        levelDesigner.setSelectedPeg(peg: peg2)
        XCTAssertNil(levelDesigner.selectedBlock, "Failed to set selectedBlock to nil")
        XCTAssertEqual(levelDesigner.selectedPeg, peg2, "Failed to set selectedPeg")
        XCTAssertEqual(levelDesigner.diameter, peg2.diameter, "Failed to set diameter")
        XCTAssertEqual(levelDesigner.rotation, peg2.rotation, "Failed to set rotation")
        XCTAssertNil(levelDesigner.height, "Failed to set height")
        XCTAssertNil(levelDesigner.width, "Failed to set width")

        levelDesigner.setSelectedPeg(peg: nil)
        XCTAssertNil(levelDesigner.selectedBlock, "Failed to set selectedBlock to nil")
        XCTAssertNil(levelDesigner.selectedPeg, "Failed to set selectedPeg to nil")
        XCTAssertNil(levelDesigner.diameter, "Failed to set diameter to nil")
        XCTAssertNil(levelDesigner.rotation, "Failed to set rotation to nil")
        XCTAssertNil(levelDesigner.height, "Failed to set height to nil")
        XCTAssertNil(levelDesigner.width, "Failed to set width to nil")
    }

    func testSetSelectedBlock() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let block1 = Block(id: UUID(), position: CGPoint(x: 100, y: 100))
        let block2 = Block(id: UUID(), position: CGPoint(x: 200, y: 200))
        levelDesigner.gameboard.addBlock(block: block1)
        levelDesigner.gameboard.addBlock(block: block2)

        levelDesigner.setSelectedBlock(block: block1)
        XCTAssertNil(levelDesigner.selectedPeg, "Failed to set selectedPeg to nil")
        XCTAssertEqual(levelDesigner.selectedBlock, block1, "Failed to set selectedBlock")
        XCTAssertNil(levelDesigner.diameter, "Failed to set diameter")
        XCTAssertEqual(levelDesigner.rotation, block1.rotation, "Failed to set rotation")
        XCTAssertEqual(levelDesigner.height, block1.height, "Failed to set height")
        XCTAssertEqual(levelDesigner.width, block1.width, "Failed to set width")

        levelDesigner.setSelectedBlock(block: block2)
        XCTAssertNil(levelDesigner.selectedPeg, "Failed to set selectedPeg to nil")
        XCTAssertEqual(levelDesigner.selectedBlock, block2, "Failed to set selectedBlock")
        XCTAssertNil(levelDesigner.diameter, "Failed to set diameter")
        XCTAssertEqual(levelDesigner.rotation, block2.rotation, "Failed to set rotation")
        XCTAssertEqual(levelDesigner.height, block2.height, "Failed to set height")
        XCTAssertEqual(levelDesigner.width, block2.width, "Failed to set width")

        levelDesigner.setSelectedBlock(block: nil)
        XCTAssertNil(levelDesigner.selectedPeg, "Failed to set selectedPeg to nil")
        XCTAssertNil(levelDesigner.selectedBlock, "Failed to set selectedBlock to nil")
        XCTAssertNil(levelDesigner.diameter, "Failed to set diameter to nil")
        XCTAssertNil(levelDesigner.rotation, "Failed to set rotation to nil")
    }

    func testResizePeg() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 200, y: 200), pegtype: .GoalPeg)
        levelDesigner.gameboard.addPeg(peg: peg)
        levelDesigner.gameboard.addPeg(peg: peg2)

        levelDesigner.resizePeg(newDiameter: 100)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].diameter,
                       Peg.DEFAULT_PEG_DIAMETER,
                       "Should not resize peg if not selected")

        levelDesigner.setSelectedPeg(peg: peg)
        levelDesigner.resizePeg(newDiameter: 100)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].diameter, 100, "Failed to resize peg")

        levelDesigner.resizePeg(newDiameter: 200)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].diameter,
                       100,
                       "Should not resize peg if increasing diameter causes peg to overlap with other peg")

        levelDesigner.setPegType(pegtype: nil)
        levelDesigner.addBlock(at: CGPoint(x: 100, y: 270))
        levelDesigner.resizePeg(newDiameter: 120)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].diameter,
                       100,
                       "Should not resize peg if increasing diameter causes peg to overlap with other block")

        levelDesigner.movePeg(peg: peg, to: CGPoint(x: 400, y: 200))
        levelDesigner.resizePeg(newDiameter: 300)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].diameter,
                       100,
                       "Should not resize peg if increasing diameter causes peg to exceeds board size")

        levelDesigner.movePeg(peg: peg, to: CGPoint(x: 400, y: 300))
        levelDesigner.resizePeg(newDiameter: 250)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].diameter,
                       100,
                       "Should not resize peg if increasing diameter causes peg to enters bucket region")
    }

    func testResizeBlockHeight() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let block = Block(id: UUID(), position: CGPoint(x: 100, y: 200))
        let block2 = Block(id: UUID(), position: CGPoint(x: 100, y: 300))
        let block3 = Block(id: UUID(), position: CGPoint(x: 300, y: 200))
        let block4 = Block(id: UUID(), position: CGPoint(x: 400, y: 20))
        let block5 = Block(id: UUID(), position: CGPoint(x: 400, y: 380))
        let peg = Peg(id: UUID(), position: CGPoint(x: 300, y: 300), pegtype: .NormalPeg)
        levelDesigner.gameboard.addBlock(block: block)
        levelDesigner.gameboard.addBlock(block: block2)
        levelDesigner.gameboard.addBlock(block: block3)
        levelDesigner.gameboard.addBlock(block: block4)
        levelDesigner.gameboard.addBlock(block: block5)
        levelDesigner.gameboard.addPeg(peg: peg)

        levelDesigner.resizeBlockHeight(newHeight: 100)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].height, 25, "Should not resize block if not selected")

        levelDesigner.setSelectedBlock(block: block)
        levelDesigner.resizeBlockHeight(newHeight: 100)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].height, 100, "Failed to resize block")

        levelDesigner.resizeBlockHeight(newHeight: 200)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].height,
                       100,
                       "Should not resize block if increasing height causes block to overlap with other block")

        levelDesigner.setSelectedBlock(block: block3)
        levelDesigner.resizeBlockHeight(newHeight: 200)
        XCTAssertEqual(levelDesigner.gameboard.blocks[2].height,
                       25,
                       "Should not resize block if increasing height causes block to overlap with other peg")

        levelDesigner.setSelectedBlock(block: block4)
        levelDesigner.resizeBlockHeight(newHeight: 100)
        XCTAssertEqual(levelDesigner.gameboard.blocks[3].height,
                       25,
                       "Should not resize block if increasing height causes block to exceeds board size")

        levelDesigner.setSelectedBlock(block: block4)
        levelDesigner.resizeBlockHeight(newHeight: 250)
        XCTAssertEqual(levelDesigner.gameboard.blocks[4].height,
                       25,
                       "Should not resize block if increasing height causes block to enters bucket region")
    }

    func testResizeBlockWidth() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let block = Block(id: UUID(), position: CGPoint(x: 200, y: 100))
        let block2 = Block(id: UUID(), position: CGPoint(x: 300, y: 100))
        let block3 = Block(id: UUID(), position: CGPoint(x: 200, y: 200))
        let block4 = Block(id: UUID(), position: CGPoint(x: 30, y: 300))

        let peg = Peg(id: UUID(), position: CGPoint(x: 300, y: 200), pegtype: .NormalPeg)
        levelDesigner.gameboard.addBlock(block: block)
        levelDesigner.gameboard.addBlock(block: block2)
        levelDesigner.gameboard.addBlock(block: block3)
        levelDesigner.gameboard.addBlock(block: block4)
        levelDesigner.gameboard.addPeg(peg: peg)

        levelDesigner.resizeBlockWidth(newWidth: 100)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].width, 50, "Should not resize block if not selected")

        levelDesigner.setSelectedBlock(block: block)
        levelDesigner.resizeBlockWidth(newWidth: 100)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].width, 100, "Failed to resize block")

        levelDesigner.resizeBlockWidth(newWidth: 200)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].width,
                       100,
                       "Should not resize block if increasing width causes block to overlap with other block")

        levelDesigner.setSelectedBlock(block: block3)
        levelDesigner.resizeBlockWidth(newWidth: 200)
        XCTAssertEqual(levelDesigner.gameboard.blocks[2].width,
                       50,
                       "Should not resize block if increasing width causes block to overlap with other peg")

        levelDesigner.setSelectedBlock(block: block)
        levelDesigner.moveBlock(block: block, to: CGPoint(x: 400, y: 200))
        levelDesigner.resizeBlockWidth(newWidth: 300)
        XCTAssertEqual(levelDesigner.gameboard.blocks[3].width,
                       50,
                       "Should not resize block if increasing width causes block to exceeds board size")
    }

    func testRotateBlock() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let block = Block(id: UUID(), position: CGPoint(x: 100, y: 200))
        let block2 = Block(id: UUID(), position: CGPoint(x: 200, y: 200))
        levelDesigner.gameboard.addBlock(block: block)
        levelDesigner.gameboard.addBlock(block: block2)

        levelDesigner.rotateBlock(newAngle: 90)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].rotation, 0, "Should not rotate block if not selected")

        levelDesigner.setSelectedBlock(block: block)
        levelDesigner.rotateBlock(newAngle: 90)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].rotation, 90, "Failed to rotate block")

        levelDesigner.rotateBlock(newAngle: 180)
        XCTAssertEqual(levelDesigner.gameboard.blocks[0].rotation, 180, "Failed to rotate block")
    }

    func testRotatePeg() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 200, y: 200), pegtype: .GoalPeg)
        levelDesigner.gameboard.addPeg(peg: peg)
        levelDesigner.gameboard.addPeg(peg: peg2)

        levelDesigner.rotatePeg(newAngle: 90)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].rotation, 0, "Should not rotate peg if not selected")

        levelDesigner.setSelectedPeg(peg: peg)
        levelDesigner.rotatePeg(newAngle: 90)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].rotation, 90, "Failed to rotate peg")

        levelDesigner.rotatePeg(newAngle: 180)
        XCTAssertEqual(levelDesigner.gameboard.pegs[0].rotation, 180, "Failed to rotate peg")
    }

    func testReset() {
        let levelDesigner = LevelDesignerViewModel()
        levelDesigner.setBoardSize(newSize: CGSize(width: 500, height: 500))

        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 100), pegtype: .NormalPeg)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 200, y: 200), pegtype: .GoalPeg)
        levelDesigner.gameboard.addPeg(peg: peg)
        levelDesigner.gameboard.addPeg(peg: peg2)

        let block = Block(id: UUID(), position: CGPoint(x: 300, y: 300))
        let block2 = Block(id: UUID(), position: CGPoint(x: 400, y: 400))
        levelDesigner.gameboard.addBlock(block: block)
        levelDesigner.gameboard.addBlock(block: block2)

        levelDesigner.setSelectedBlock(block: block)
        levelDesigner.setPegType(pegtype: .GoalPeg)
        levelDesigner.toggleIsDelete()
        levelDesigner.resizePeg(newDiameter: 100)
        levelDesigner.resizeBlockHeight(newHeight: 100)
        levelDesigner.resizeBlockWidth(newWidth: 100)
        levelDesigner.rotatePeg(newAngle: 90)
        levelDesigner.rotateBlock(newAngle: 90)

        levelDesigner.reset()
        XCTAssertNil(levelDesigner.selectedPeg, "Failed to reset selectedPeg")
        XCTAssertNil(levelDesigner.selectedBlock, "Failed to reset selectedBlock")
        XCTAssertEqual(levelDesigner.pegtype, PegType.GoalPeg, "PegType should not be reset")
        XCTAssertTrue(levelDesigner.isDelete, "isDelete should not be reset")
        XCTAssertNil(levelDesigner.diameter, "Failed to reset diameter")
        XCTAssertNil(levelDesigner.rotation, "Failed to reset rotation")
        XCTAssertNil(levelDesigner.height, "Failed to reset height")
        XCTAssertNil(levelDesigner.width, "Failed to reset width")
    }
}
