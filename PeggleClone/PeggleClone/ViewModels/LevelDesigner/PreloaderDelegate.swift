//
//  PreloaderDelegate.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 28/2/24.
//

import Foundation

class PreloaderDelegate {
    func load(id: Int, gameboard: Gameboard) -> Gameboard? {
        let boardSize = gameboard.boardSize

        let gameboardMap: [Int: (CGSize) -> Gameboard] = [
            1: { self.gameboardOne(boardSize: $0) },
            2: { self.gameboardTwo(boardSize: $0) },
            3: { self.gameboardThree(boardSize: $0) }
        ]

        return gameboardMap[id]?(boardSize)
    }

    private func gameboardOne(boardSize: CGSize) -> Gameboard {
        let midX = boardSize.width / 2
        let boardLegalHeight = boardSize.height - BucketGameObject.DEFAULT_BUCKET_HEIGHT
        let heightFifty = boardLegalHeight * 0.5

        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: midX - 50, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 101, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 152, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 50, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 101, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 152, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width - 26, y: heightFifty), pegtype: .KaboomPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 75, y: heightFifty + 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 75, y: heightFifty + 50), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX, y: heightFifty + 150), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX * 0.2, y: boardLegalHeight * 0.1), pegtype: .SpookyPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width - 26, y: boardLegalHeight * 0.8), pegtype: .GoalPeg)
        ]

        let blocks: [Block] = []

        return Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
    }

    private func gameboardTwo(boardSize: CGSize) -> Gameboard {
        let boardLegalHeight = boardSize.height - BucketGameObject.DEFAULT_BUCKET_HEIGHT
        let heightFifty = boardLegalHeight / 2
        let heightThirty = boardLegalHeight * 0.3
        let hieghtSeventy = boardLegalHeight * 0.7

        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: boardSize.width * 0.3, y: heightFifty), pegtype: .StubbornPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width * 0.7, y: heightFifty), pegtype: .StubbornPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width * 0.4, y: hieghtSeventy), pegtype: .HealthPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width * 0.6, y: hieghtSeventy), pegtype: .HealthPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width * 0.4, y: heightThirty), pegtype: .HealthPeg),
            Peg(id: UUID(), position: CGPoint(x: boardSize.width * 0.6, y: heightThirty), pegtype: .GoalPeg)
        ]

        let blocks = [
            Block(id: UUID(), position: CGPoint(x: boardSize.width * 0.2, y: heightThirty), rotation: 135),
            Block(id: UUID(), position: CGPoint(x: boardSize.width * 0.8, y: hieghtSeventy), rotation: 135),
            Block(id: UUID(), position: CGPoint(x: boardSize.width * 0.8, y: heightThirty), rotation: 45),
            Block(id: UUID(), position: CGPoint(x: boardSize.width * 0.2, y: hieghtSeventy), rotation: 45)
        ]

        return Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
    }

    private func gameboardThree(boardSize: CGSize) -> Gameboard {
        let midX = boardSize.width / 2
        let boardLegalHeight = boardSize.height - BucketGameObject.DEFAULT_BUCKET_HEIGHT
        let heightFifty = boardLegalHeight * 0.5

        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: midX - 51, y: heightFifty - 102), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 102, y: heightFifty - 102), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 102, y: heightFifty - 51), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 102, y: heightFifty), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 102, y: heightFifty + 51), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 102, y: heightFifty + 102), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX - 51, y: heightFifty + 102), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX, y: heightFifty + 102), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 51, y: heightFifty + 102), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 102, y: heightFifty + 102), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 102, y: heightFifty + 51), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 102, y: heightFifty), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 102, y: heightFifty - 51), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 102, y: heightFifty - 102), pegtype: .NormalPeg),
            Peg(id: UUID(), position: CGPoint(x: midX + 51, y: heightFifty - 102), pegtype: .GoalPeg)
        ]

        let blocks: [Block] = []

        return Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
    }
}
