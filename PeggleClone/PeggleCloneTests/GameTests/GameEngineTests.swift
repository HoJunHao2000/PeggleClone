//
//  GameEngineTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 9/2/24.
//

import XCTest
@testable import PeggleClone

final class GameEngineTests: XCTestCase {
    func testGameEngineInitialization() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)

        XCTAssertNotNil(gameEngine, "GameEngine should not be nil")
        XCTAssertNotNil(gameEngine.physicsEngine, "GameEngine's physicsEngine should not be nil")
        XCTAssertNotNil(gameEngine.gameboard, "GameEngine's gameboard should not be nil")
        XCTAssertEqual(gameEngine.pegs.count, pegs.count, "Number of pegs should match")
        XCTAssertEqual(gameEngine.removedPegs.count, 0, "No pegs should be removed initially")
        XCTAssertNil(gameEngine.ball, "No ball should be present initially")
        XCTAssertEqual(gameEngine.score, 0, "Score should be initialized to 0")
        XCTAssertEqual(gameEngine.ballsRemaining, 10, "Initial number of balls should match")
    }

    func testIsReadyToShoot() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)

        // Initial state
        XCTAssertTrue(gameEngine.isReadyToShoot, "Expected to be ready to shoot initially")

        // Launch a ball
        gameEngine.launchBall(point: CGPoint(x: 150, y: 150))
        gameEngine.update(timeDelta: 0.01)
        XCTAssertFalse(gameEngine.isReadyToShoot, "Expected not to be ready to shoot after launching a ball")

        // Move the ball out of bounds
        gameEngine.ball?.physicsObject.setPosition(newPosition: CGPoint(x: 150, y: 460))
        gameEngine.update(timeDelta: 0.01)
        XCTAssertTrue(gameEngine.isReadyToShoot, "Expected to be ready to shoot after moving the ball out of bounds")
    }

    func testIsBallOutOfBounds() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)

        // Initial State
        XCTAssertFalse(gameEngine.isBallOutOfBounds, "Ball not created yet, assume still within bounds")

        // Launch ball
        gameEngine.launchBall(point: CGPoint(x: 100, y: 100))
        gameEngine.update(timeDelta: 0.01)
        XCTAssertFalse(gameEngine.isBallOutOfBounds, "Ball just created and launched should still be in board")

        // Move the ball out of bounds
        gameEngine.ball?.physicsObject.setPosition(newPosition: CGPoint(x: 150, y: 460))
        XCTAssertTrue(gameEngine.isBallOutOfBounds, "Expected ball to be out of bounds when moved outside board")
    }

    func testIsWin() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)
        // Game not over initially
        XCTAssertFalse(gameEngine.isWin, "Expected to not win initially")

        // Hit and remove all pegs
        for peg in gameEngine.pegs {
            XCTAssertFalse(gameEngine.isWin, "Pegs still present, haven't win")

            gameEngine.launchBall(point: peg.position)
            gameEngine.ball?.physicsObject.setPosition(newPosition: peg.position)
            gameEngine.update(timeDelta: 0.01)
            gameEngine.ball?.physicsObject.setPosition(newPosition: CGPoint(x: 200, y: 600))
            gameEngine.update(timeDelta: 0.01)
        }
        XCTAssertTrue(gameEngine.isWin, "Expected to win after removing all pegs")
    }

    func testIsGameOver() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)

        XCTAssertFalse(gameEngine.isGameOver, "Expected game not to be over in the beginning.")

        // Use up all balls
        for _ in 0..<10 {
            XCTAssertFalse(gameEngine.isGameOver, "Balls still remaining, game not over")

            gameEngine.launchBall(point: CGPoint(x: 150, y: 150))
            gameEngine.ball?.physicsObject.setPosition(newPosition: CGPoint(x: 150, y: 450))
            gameEngine.update(timeDelta: 0.01)
        }
        XCTAssertTrue(gameEngine.isGameOver, "Expected game to be over after using up all balls")
    }

    func testLaunchBall() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)

        // Launch a ball when not game over
        gameEngine.launchBall(point: CGPoint(x: 150, y: 150))
        gameEngine.update(timeDelta: 0.01)
        XCTAssertEqual(gameEngine.ballsRemaining, 10 - 1, "Expected one less ball remaining after launch")
        XCTAssertNotNil(gameEngine.ball, "Expected a ball object after launch")
        XCTAssertFalse(gameEngine.isReadyToShoot, "Expected not ready to shoot after launch")

        // Attempt to launch a ball with another ball in play
        let initialBallsRemaining = gameEngine.ballsRemaining
        let oldBallPosition = gameEngine.ball?.position
        gameEngine.launchBall(point: CGPoint(x: 150, y: 150))
        XCTAssertEqual(gameEngine.ballsRemaining,
                       initialBallsRemaining,
                       "Expected no change in balls remaining after launch")
        XCTAssertEqual(gameEngine.ball?.position,
                       oldBallPosition,
                       "Ball position should not change after launching again")
        XCTAssertNotNil(gameEngine.ball, "Ball should not disappear")
    }

    func testLaunchBallAfterGameOver() {
        let boardSize = CGSize(width: 400, height: 400)
        let pegs = [
            Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .GoalPeg),
            Peg(id: UUID(), position: CGPoint(x: 150, y: 250), pegtype: .GoalPeg)
        ]
        let blocks = [
            Block(id: UUID(), position: CGPoint(x: 250, y: 250), size: CGSize(width: 50, height: 50), rotation: 0.0),
            Block(id: UUID(), position: CGPoint(x: 350, y: 350), size: CGSize(width: 50, height: 50), rotation: 0.0)
        ]
        let gameboard = Gameboard(id: UUID(), name: "", boardSize: boardSize, pegs: pegs, blocks: blocks)
        let gameEngine = GameEngine(gameboard: gameboard)

        // Trying to launch ball when game is over
        for _ in 0..<10 {
            gameEngine.launchBall(point: CGPoint(x: 150, y: 150))
            gameEngine.ball?.physicsObject.setPosition(newPosition: CGPoint(x: 150, y: 450))
            gameEngine.update(timeDelta: 0.01)
        }
        XCTAssertEqual(gameEngine.ballsRemaining, 0, "Expected 0 balls remaining")
        gameEngine.launchBall(point: CGPoint(x: 150, y: 150))
        XCTAssertEqual(gameEngine.ballsRemaining, 0, "Expected balls remain at 0")
        XCTAssertNil(gameEngine.ball, "Expected no ball object after attempting to launch ball when game is over")
    }
}
