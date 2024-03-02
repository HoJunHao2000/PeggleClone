/**
 The `GameEngine` class represents the game engine for a Peggle-like game.
 It manages the game state, physics, and game logic.

 ## Representation Invariants for Every `GameEngine`:
 - The number of removed pegs must be at least 0 and not more than the total number of pegs.
 - The score must be at least 0.
 - The number of balls remaining must be at least 0.
 - If the `ball` is not `nil`, it must have a corresponding physics object in the `physicsEngine`.
 - If the `ball` is not `nil`, its position must be within the game boundary.
 - All pegs in the `pegs` array that are not in `removedPegs` must have a corresponding physics object
 in the `physicsEngine`.
 - All pegs in the `removedPegs` set must have been removed from the `physicsEngine`.
 - All blocks in the `blocks` array must have a corresponding physics object in the `physicsEngine`
 - Bucket must have a corresponding physics object in `physicsEngine`

 - Authors: CS3217, HoJunHao2000
 */

import Foundation

class GameEngine {
    static let INITIAL_NUMBER_OF_BALLS = 10
    static let INIITAL_BALL_SPEED: Double = 1_200
    static let GRAVITY = CGVector(dx: 0.0, dy: 981)

    let gameboard: Gameboard

    private(set) var physicsEngine: PhysicsEngine
    private(set) var pegs: [PegGameObject]
    private(set) var blocks: [BlockGameObject]
    private(set) var bucket: BucketGameObject
    private(set) var ball: BallGameObject?
    private(set) var removedPegs: Set<PegGameObject>
    private(set) var score: Int
    private(set) var ballsRemaining: Int
    private(set) var pegsRemainingByType: [PegType: Int]
    private(set) var isSpooky: Bool

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
        self.bucket = BucketGameObject(boardSize: gameboard.boardSize)
        self.isSpooky = false

        physicsEngine.addPhysicsObject(physicsObject: bucket.physicsObject)
        addPegsBlocksIntoGame(pegs: gameboard.pegs, blocks: gameboard.blocks)
        addPhysicsBoundary(boardSize: gameboard.boardSize)

        assert(checkRepresentation())
    }

    var isReadyToShoot: Bool {
        assert(checkRepresentation())

        return !isGameOver && !isWin && ballsRemaining > 0 && ball == nil
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

        let bucketTopCheck = ball.position.y + (ball.diameter / 2) > bucket.position.y - (bucket.height / 2)
        let bucketLeftCheck = ball.position.x > bucket.position.x - (bucket.width / 2)
        let bucketRightCheck = ball.position.x < bucket.position.x + (bucket.width / 2)
        let bucketCheck = bucketTopCheck && bucketLeftCheck && bucketRightCheck

        return bottomCheck || topCheck || rightCheck || leftCheck || bucketCheck
    }

    var isGameOver: Bool {
        assert(checkRepresentation())

        return (ballsRemaining == 0 && ball == nil) && pegsRemainingByType[.GoalPeg, default: 0] > 0
    }

    var isWin: Bool {
        assert(checkRepresentation())

        return pegsRemainingByType[.GoalPeg, default: 0] == 0
    }

    func launchBall(point: CGPoint) {
        assert(checkRepresentation())

        guard isReadyToShoot else {
            return
        }

        let newBall = makeNewBall(point: point)
        physicsEngine.addPhysicsObject(physicsObject: newBall.physicsObject)
        ball = newBall

        assert(checkRepresentation())
    }

    func setIsSpooky() {
        isSpooky = true
    }

    func update(timeDelta: TimeInterval) {
        assert(checkRepresentation())

        guard timeDelta > 0 else {
            return
        }

        physicsEngine.updatePhysicsObjects(timeDelta: timeDelta)
        applyPowerUps()
        removePegsPremature()
        removeBallAndPegsIfExit()

        assert(checkRepresentation())
    }

    private func applyPowerUps() {
        guard ball != nil && !isGameOver && !isWin else {
            return
        }

        for peg in pegs where !removedPegs.contains(peg) {
            peg.powerup?.powerup(peg: peg, gameEngine: self)
        }
    }

    private func addPegsBlocksIntoGame(pegs: [Peg], blocks: [Block]) {
        let pegtypemap: [PegType: (Peg) -> PegGameObject] = [
            .NormalPeg: { peg in NormalPegGameObject(peg: peg) },
            .GoalPeg: { peg in  GoalPegGameObject(peg: peg) },
            .KaboomPeg: { peg in KaboomPegGameObject(peg: peg) },
            .SpookyPeg: { peg in SpookyPegGameObject(peg: peg) },
            .HealthPeg: { peg in HealthPegGameObject(peg: peg) },
            .StubbornPeg: { peg in StubbornPegGameObject(peg: peg) }
        ]

        for peg in pegs {
            pegsRemainingByType[peg.pegtype, default: 0] += 1

            if let pegGameObject = pegtypemap[peg.pegtype]?(peg) {
                self.pegs.append(pegGameObject)
                physicsEngine.addPhysicsObject(physicsObject: pegGameObject.physicsObject)
            }
        }

        for block in blocks {
            let blockGameObject = BlockGameObject(block: block)
            self.blocks.append(blockGameObject)
            physicsEngine.addPhysicsObject(physicsObject: blockGameObject.physicsObject)
        }
    }

    private func addPhysicsBoundary(boardSize: CGSize) {
        let topBoundary = LinePhysicsObject(startPoint: .zero,
                                            endPoint: CGPoint(x: boardSize.width, y: 0))
        let leftBoundary = LinePhysicsObject(startPoint: CGPoint(x: 0, y: boardSize.height),
                                             endPoint: .zero)
        let rightBoundary = LinePhysicsObject(startPoint: CGPoint(x: boardSize.width, y: 0),
                                              endPoint: CGPoint(x: boardSize.width, y: boardSize.height))

        physicsEngine.addPhysicsObject(physicsObject: topBoundary)
        physicsEngine.addPhysicsObject(physicsObject: leftBoundary)
        physicsEngine.addPhysicsObject(physicsObject: rightBoundary)
    }

    private func makeNewBall(point: CGPoint) -> BallGameObject {
        let initialPosition = CGPoint(x: gameboard.boardSize.width / 2, y: BallGameObject.DEFAULT_BALL_DIAMETER / 2)
        let initialVector = CGVector(dx: point.x - initialPosition.x, dy: point.y - initialPosition.y)
        let normalisedVelocity = Utils.normalize(initialVector)
        let initialVelocity = Utils.scaleBy(normalisedVelocity, n: GameEngine.INIITAL_BALL_SPEED)

        let newBall = BallGameObject(initialPosition: initialPosition,
                                     initialForce: GameEngine.GRAVITY,
                                     initialVelocity: initialVelocity)
        ballsRemaining -= 1
        return newBall
    }

    private func removeBallAndPegsIfExit() {
        guard let ball = self.ball, isBallOutOfBounds else {
            return
        }

        if bucket.isBallEnter {
            SoundManager.instance.playSound(.score)
            bucket.physicsObject.resetHitCount()
            if !isSpooky {
                ballsRemaining += 1
            }
            score += 500
        }

        if isSpooky {
            SoundManager.instance.playSound(.spooky)
            let newPosition = CGPoint(x: ball.position.x, y: BallGameObject.DEFAULT_BALL_DIAMETER / 2)
            ball.physicsObject.setPosition(newPosition: newPosition)
            ball.physicsObject.setVelocity(newVelocity: .zero)

            self.isSpooky = false
            return
        }

        physicsEngine.removePhysicsObject(physicsObject: ball.physicsObject)
        self.ball = nil

        for peg in pegs where peg.isLit && !removedPegs.contains(peg) {
            removePeg(peg)
        }

        addAttemptScore()
    }

    private func addAttemptScore() {
        let pegPointMap: [PegType: Int] = [
            .NormalPeg: 10,
            .GoalPeg: 100,
            .KaboomPeg: 50,
            .SpookyPeg: 0,
            .HealthPeg: 30,
            .StubbornPeg: 20
        ]

        let numOfOrangeLeft = pegsRemainingByType[.GoalPeg] ?? 0
        let multiplier = numOfOrangeLeft == 0 ? 100
                        : numOfOrangeLeft < 4 ? 10
                        : numOfOrangeLeft < 8 ? 5
                        : numOfOrangeLeft < 11 ? 3
                        : 1

        for (pegType, count) in pegHitsCount {
            if let points = pegPointMap[pegType] {
                score += points * count * multiplier
            }
        }

        pegHitsCount = [:]
    }

    private func removePegsPremature() {
        for peg in pegs where !removedPegs.contains(peg) {
            let maxPegHeight = gameboard.boardSize.height - BucketGameObject.DEFAULT_BUCKET_HEIGHT - (peg.diameter / 2)
            if peg.shouldRemove || peg.position.y > maxPegHeight {
                removePeg(peg)
            }
        }
    }

    private func removePeg(_ peg: PegGameObject) {
        if let count = pegsRemainingByType[peg.pegtype] {
            pegsRemainingByType[peg.pegtype] = count - 1
        }

        physicsEngine.removePhysicsObject(physicsObject: peg.physicsObject)
        pegHitsCount[peg.pegtype, default: 0] += 1
        removedPegs.insert(peg)
    }
}

extension GameEngine {
    private func checkRepresentation() -> Bool {
        // number of removed pegs must be not more than number of pegs
        guard removedPegs.count <= pegs.count else {
            return false
        }

        // number of balls remaining must be at least 0
        guard ballsRemaining >= 0 else {
            return false
        }

        // if balls is not nil
        if let mainBall = ball {
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

        // all blocks must have a corresponding physics object in the physics engine
        for block in blocks
            where !physicsEngine.physicsObjects.contains(where: { $0 === block.physicsObject }) {
                return false
            }

        // bucket must have a corresponding physics object in the physics engine
        guard physicsEngine.physicsObjects.contains(where: { $0 === bucket.physicsObject }) else {
            return false
        }

        return true
    }
}
