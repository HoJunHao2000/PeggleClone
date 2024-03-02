//
//  GameViewModel.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import Foundation
import QuartzCore

class GameViewModel: ObservableObject {
    private static let SECONDS_ELAPSED_PER_FRAME: Double = 1 / 120
    private static let GAME_DURATION: Double = 300

    private(set) var gameEngine: GameEngine
    private(set) var cannonAngle: Double
    private var displayLink: CADisplayLink?
    private var previousTime: TimeInterval
    private var lag: Double
    private var preload: Int
    private(set) var hasPreloaded: Bool
    private var timer: Timer?
    private(set) var remainingTime: TimeInterval = GAME_DURATION

    private let preloader = PreloaderDelegate()

    init(gameboard: Gameboard) {
        self.gameEngine = GameEngine(gameboard: gameboard)
        self.cannonAngle = 0.0
        self.previousTime = Date().timeIntervalSince1970
        self.lag = 0
        self.hasPreloaded = true
        self.preload = -1
    }

    init(preload: Int) {
        let emptyGameboard = Gameboard(id: UUID(),
                                       name: "",
                                       boardSize: CGSize(width: CGFloat.infinity, height: CGFloat.infinity),
                                       pegs: [],
                                       blocks: [])
        self.gameEngine = GameEngine(gameboard: emptyGameboard)
        self.cannonAngle = 0.0
        self.previousTime = Date().timeIntervalSince1970
        self.lag = 0
        self.hasPreloaded = false
        self.preload = preload
    }

    var blocks: [BlockGameObject] {
        gameEngine.blocks
    }

    var bucket: BucketGameObject {
        gameEngine.bucket
    }

    var pegs: [PegGameObject] {
        gameEngine.pegs
    }

    var pegsRemainingMap: [PegType: Int] {
        gameEngine.pegsRemainingByType
    }

    var ball: BallGameObject? {
        gameEngine.ball
    }

    var boardSize: CGSize {
        gameEngine.gameboard.boardSize
    }

    var score: Int {
        gameEngine.score
    }

    var isGameOver: Bool {
        guard hasPreloaded else {
            return false
        }

        return gameEngine.isGameOver || remainingTime <= 0
    }

    var isWin: Bool {
        guard hasPreloaded else {
            return false
        }

        return gameEngine.isWin && remainingTime > 0
    }

    var ballsRemaining: Int {
        gameEngine.ballsRemaining
    }

    var isSpooky: Bool {
        gameEngine.isSpooky
    }

    func loadPreloadGameboard(boardSize: CGSize) {
        guard !hasPreloaded else {
            return
        }

        if let preloadedGameboard = preloader.load(id: preload, boardSize: boardSize) {
            self.gameEngine = GameEngine(gameboard: preloadedGameboard)
            self.cannonAngle = 0.0
            self.previousTime = Date().timeIntervalSince1970
            self.hasPreloaded = true

            objectWillChange.send()
        }
    }

    func end() {
        self.displayLink?.invalidate()
        self.displayLink = nil
        self.timer?.invalidate()
        self.timer = nil
    }

    func shoot(at: CGPoint) {
        guard gameEngine.isReadyToShoot && at.y >= 0 else {
            return
        }

        gameEngine.launchBall(point: at)
        createDisplayLink()
    }

    func adjustCannonAngle(point: CGPoint) {
        let deltaX = point.x - (boardSize.width / 2)
        let deltaY = point.y - 0
        let angleRadians = atan2(deltaY, deltaX)
        let angleDegrees = angleRadians * 180.0 / Double.pi
        let angleToRotate = -(90.0 - angleDegrees)

        guard angleToRotate <= 90 && angleToRotate >= -90 else {
            return
        }

        self.cannonAngle = angleToRotate
        objectWillChange.send()
    }

    private func createDisplayLink() {
        guard self.displayLink == nil && self.timer == nil else {
            return
        }

        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(step)
        )
        let timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerStep),
                                         userInfo: nil,
                                         repeats: true)
        displayLink.add(to: .main, forMode: .default)
        self.displayLink = displayLink
        self.previousTime = Date().timeIntervalSince1970
        self.timer = timer
    }

    @objc private func step(displayLink: CADisplayLink) {
        let currentTime = Date().timeIntervalSince1970
        let elapsed = currentTime - previousTime
        previousTime = currentTime
        lag += elapsed

        while lag >= GameViewModel.SECONDS_ELAPSED_PER_FRAME {
            gameEngine.update(timeDelta: GameViewModel.SECONDS_ELAPSED_PER_FRAME)
            lag -= GameViewModel.SECONDS_ELAPSED_PER_FRAME
        }

        objectWillChange.send()
    }

    @objc private func timerStep() {
        remainingTime -= 1
        remainingTime = max(0, remainingTime)
    }
}
