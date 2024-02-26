/**
 The `GameEngine` class represents the game engine for a Peggle-like game.
 It manages the game state, physics, and game logic.

 ## Information contained in `GameEngine`:
 - Gameboard: The gameboard on which the game is played.
 - Physics Engine: Manages the physics of the game objects.
 - Pegs: The pegs present on the gameboard.
 - Removed Pegs: Pegs that have been removed from the gameboard.
 - Ball: The ball currently in play.
 - Score: The player's score.
 - Balls Remaining: The number of balls remaining to be played.
 - isReadyToShoot: Whether the game is in a state to shoot another ball
 - isBallOutOfBounds: Whether the game ball is outside the boundary of game

 ## Representation Invariants for Every `GameEngine`:
 - The total number of pegs in the `pegs` array must equal the number of pegs in the `gameboard.pegs` array.
 - The number of removed pegs must be at least 0 and not more than the total number of pegs.
 - The score must be at least 0 and equal to the number of removed pegs.
 - The number of balls remaining must be at least 0 and not more than the initial number of balls.
 - If the `ball` is not `nil`, the number of balls remaining must be less than the initial number of balls.
 - If the `ball` is not `nil`, it must have a corresponding physics object in the `physicsEngine`.
 - If the `ball` is not `nil`, its position must be within the game boundary.
 - All pegs in the `pegs` array that are not in `removedPegs` must have a corresponding physics object
 in the `physicsEngine`.
 - All pegs in the `removedPegs` set must have been removed from the `physicsEngine`.

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class GameEngine {
    private static let INITIAL_NUMBER_OF_BALLS = 10
    private static let INIITAL_BALL_SPEED: Double = 1_200
    private static let GRAVITY = CGVector(dx: 0.0, dy: 981)

    let gameboard: Gameboard

    private(set) var physicsEngine: PhysicsEngine
    private(set) var pegs: [PegGameObject]
    private(set) var blocks: [BlockGameObject]
    private(set) var removedPegs: Set<PegGameObject>
    private(set) var ball: BallGameObject?
    private(set) var score: Int = 0
    private(set) var ballsRemaining: Int
    private(set) var pegsRemainingByType: [PegType: Int]

    private var pegHitsCount: [PegType: Int]

    init(gameboard: Gameboard) {
        self.physicsEngine = PhysicsEngine()
        self.gameboard = gameboard
        self.pegs = []
        self.blocks = []
        self.removedPegs = []
        self.score = 0
        self.ballsRemaining = GameEngine.INITIAL_NUMBER_OF_BALLS
        self.pegsRemainingByType = [:]
        self.pegHitsCount = [:]

        addPegsIntoGame(pegs: gameboard.pegs)
        addBlocksIntoGame(blocks: gameboard.blocks)
        addPhysicsBoundary(boardSize: gameboard.boardSize)

        assert(checkRepresentation())
    }

    var isReadyToShoot: Bool {
        assert(checkRepresentation())

        return !isGameOver && ballsRemaining > 0 && ball == nil
    }

    var isBallOutOfBounds: Bool {
        assert(checkRepresentation())

        guard let ball = ball else {
            return false
        }

        let bottomCheck = ball.position.y > gameboard.boardSize.height - (ball.diameter / 2)
        let topCheck = ball.position.y < 0
        let leftCheck = ball.position.x < 0
        let rightCheck = ball.position.x > gameboard.boardSize.width

        return bottomCheck || topCheck || rightCheck || leftCheck
    }

    var isGameOver: Bool {
        assert(checkRepresentation())

        return (ballsRemaining == 0 && ball == nil) && pegsRemainingByType[.GoalPeg, default: 1] > 0
    }

    var isWin: Bool {
        assert(checkRepresentation())

        return ballsRemaining >= 0 && pegsRemainingByType[.GoalPeg, default: 0] == 0
    }

    func launchBall(point: CGPoint) {
        assert(checkRepresentation())

        guard isReadyToShoot else {
            return
        }

        let newBall = makeNewBall(point: point)
        physicsEngine.addPhysicsObject(physicsObject: newBall.physicsObject)
        ball = newBall
        ballsRemaining -= 1

        assert(checkRepresentation())
    }

    func update(timeDelta: TimeInterval) {
        assert(checkRepresentation())

        guard timeDelta > 0 else {
            return
        }

        physicsEngine.updatePhysicsObjects(timeDelta: timeDelta)
        removePegsPremature()
        removeBallAndPegsIfExit()

        assert(checkRepresentation())
    }

    func reset() {
        assert(checkRepresentation())

        physicsEngine = PhysicsEngine()
        pegs = []
        removedPegs = []
        pegsRemainingByType = [:]
        pegHitsCount = [:]
        ball = nil
        score = 0
        ballsRemaining = GameEngine.INITIAL_NUMBER_OF_BALLS

        addPegsIntoGame(pegs: gameboard.pegs)
        addBlocksIntoGame(blocks: gameboard.blocks)
        addPhysicsBoundary(boardSize: gameboard.boardSize)

        assert(checkRepresentation())
    }

    private func resetHitCount() {
        assert(checkRepresentation())

        physicsEngine.resetAllHitCount()

        assert(checkRepresentation())
    }

    private func addPegsIntoGame(pegs: [Peg]) {
        for peg in pegs {
            pegsRemainingByType[peg.pegtype, default: 0] += 1

            let pegGameObject = PegGameObject(peg: peg)
            self.pegs.append(pegGameObject)
            physicsEngine.addPhysicsObject(physicsObject: pegGameObject.physicsObject)
        }
    }

    private func addBlocksIntoGame(blocks: [Block]) {
        for block in blocks {
            let blockGameObject = BlockGameObject(block: block)
            self.blocks.append(blockGameObject)
            physicsEngine.addPhysicsObject(physicsObject: blockGameObject.physicsObject)
        }
    }

    private func addPhysicsBoundary(boardSize: CGSize) {
        let topBoundary = LinePhysicsObject(startPoint: CGPoint(x: 0, y: 0),
                                            endPoint: CGPoint(x: boardSize.width, y: 0))
        let leftBoundary = LinePhysicsObject(startPoint: CGPoint(x: 0, y: 0),
                                             endPoint: CGPoint(x: 0, y: boardSize.height))
        let rightBoundary = LinePhysicsObject(startPoint: CGPoint(x: boardSize.width, y: 0),
                                              endPoint: CGPoint(x: boardSize.width, y: boardSize.height))

        physicsEngine.addPhysicsObject(physicsObject: topBoundary)
        physicsEngine.addPhysicsObject(physicsObject: leftBoundary)
        physicsEngine.addPhysicsObject(physicsObject: rightBoundary)
    }

    private func makeNewBall(point: CGPoint) -> BallGameObject {
        let initialPosition = CGPoint(x: gameboard.boardSize.width / 2, y: BallGameObject.DEFAULT_BALL_DIAMETER / 2)
        let initialVelocity = calculateInitialVelocity(startPoint: initialPosition, endPoint: point)

        let newBall = BallGameObject(initialPosition: initialPosition,
                                     initialForce: GameEngine.GRAVITY,
                                     initialVelocity: initialVelocity,
                                     diameter: BallGameObject.DEFAULT_BALL_DIAMETER)

        return newBall
    }

    private func calculateInitialVelocity(startPoint: CGPoint, endPoint: CGPoint) -> CGVector {
        let displacementVector = CGVector(dx: endPoint.x - startPoint.x,
                                          dy: endPoint.y - startPoint.y)
        let displacementLength = sqrt(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2))
        let scaleFactor = GameEngine.INIITAL_BALL_SPEED / displacementLength
        let scaledVector = CGVector(dx: displacementVector.dx * scaleFactor, dy: displacementVector.dy * scaleFactor)

        return scaledVector
    }

    private func removeBallAndPegsIfExit() {
        guard let ball = self.ball, isBallOutOfBounds else {
            return
        }

        physicsEngine.removePhysicsObject(physicsObject: ball.physicsObject)
        self.ball = nil

        for peg in pegs where peg.isLit && !removedPegs.contains(peg) {
            if let count = pegsRemainingByType[peg.pegtype] {
                pegsRemainingByType[peg.pegtype] = count - 1
            }

            physicsEngine.removePhysicsObject(physicsObject: peg.physicsObject)
            pegHitsCount[peg.pegtype, default: 0] += 1
            removedPegs.insert(peg)
        }

        addAttemptScore()
        resetHitCount()
    }

    private func addAttemptScore() {
        let pegPointMap: [PegType: Int] = [
            .NormalPeg: 10,
            .GoalPeg: 100,
            .PowerUpPeg: 10,
            .HealthPeg: 30,
            .StubbornPeg: 20
        ]

        let numOfOrangeLeft = pegsRemainingByType[.GoalPeg] ?? 0

        var multiplier: Int = 1
        if numOfOrangeLeft == 0 {
            multiplier = 100
        } else if numOfOrangeLeft < 4 {
            multiplier = 10
        } else if numOfOrangeLeft < 8 {
            multiplier = 5
        } else if numOfOrangeLeft < 11 {
            multiplier = 3
        }

        var totalScore = 0
        for (pegType, count) in pegHitsCount {
            let basePoints = pegPointMap[pegType] ?? 0
            totalScore += basePoints * count
        }

        score += (totalScore * multiplier)
        pegHitsCount = [:]
    }

    private func removePegsPremature() {
        for peg in pegs where peg.shouldRemove && !removedPegs.contains(peg) {
            if let count = pegsRemainingByType[peg.pegtype] {
                pegsRemainingByType[peg.pegtype] = count - 1
            }

            physicsEngine.removePhysicsObject(physicsObject: peg.physicsObject)
            pegHitsCount[peg.pegtype, default: 0] += 1
            removedPegs.insert(peg)
        }
    }

    private func checkRepresentation() -> Bool {
        // totals pegs in game engine must equal pegs in gameboard
        guard gameboard.pegs.count == pegs.count else {
            return false
        }

        // number of removed pegs must be not more than number of pegs
        guard removedPegs.count <= pegs.count else {
            return false
        }

        // number of balls remaining must be at least 0 and not more than initial number of balls
        guard ballsRemaining >= 0 && ballsRemaining <= GameEngine.INITIAL_NUMBER_OF_BALLS else {
            return false
        }

        // if balls is not nil
        if let mainBall = ball {
            // number of balls remaining must be less than initial number of balls
            guard ballsRemaining < GameEngine.INITIAL_NUMBER_OF_BALLS else {
                return false
            }

            // ball game object must have a physics object in physics engine
            guard physicsEngine.physicsObjects.contains(where: { $0 === mainBall.physicsObject }) else {
                return false
            }

            // ball is always within game boundary except when going down
            guard mainBall.position.x >= 0,
                  mainBall.position.x <= gameboard.boardSize.width,
                  mainBall.position.y >= 0 else {
                return false
            }
        }

        // all game object pegs not removed must have a responding physics object in physics engine
        for peg in pegs
            where !removedPegs.contains(peg)
                && !physicsEngine.physicsObjects.contains(where: { $0 === peg.physicsObject }) {
                return false
            }

        // all pegs in removedPegs have been removed form physics engine
        for removedPeg in removedPegs
            where physicsEngine.physicsObjects.contains(where: { $0 === removedPeg.physicsObject }) {
                return false
            }

        return true
    }
}
