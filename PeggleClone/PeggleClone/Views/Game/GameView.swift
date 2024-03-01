//
//  GameView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel

    init(gameboard: Gameboard) {
        self.gameViewModel = GameViewModel(gameboard: gameboard)
    }

    init(preload: Int) {
        self.gameViewModel = GameViewModel(preload: preload)
    }

    var body: some View {
        VStack {
            GameLevelView(gameViewModel: gameViewModel)
            StatsView(gameViewModel: gameViewModel)
        }
        .alert("Game Over",
               isPresented: Binding(get: { gameViewModel.isGameOver }, set: { _, _ in }),
               actions: {
                   Button("Replay", action: { gameViewModel.reset() })
                       .onAppear(perform: {
                           gameViewModel.end()
                       })
               },
               message: {
                   Text("Your Score: \(gameViewModel.score)")
               })
        .alert("You Won!",
               isPresented: Binding(get: { gameViewModel.isWin }, set: { _, _ in }),
               actions: {
                   Button("Replay", action: { gameViewModel.reset() })
                       .onAppear(perform: {
                           gameViewModel.end()
                       })
               },
               message: {
                   Text("Your Score: \(gameViewModel.score)")
               })
    }
}

private struct GameLevelView: View {
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                boardView(boardSize: geometry.size)
                cannonView
                pegsView
                blocksView
                bucketView
                if let ball = gameViewModel.ball {
                    ballView(ball: ball)
                }
            }
            .onAppear {
                if !gameViewModel.hasPreloaded {
                    gameViewModel.loadPreloadGameboard(boardSize: geometry.size)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        gameViewModel.adjustCannonAngle(point: gesture.location)
                    }
                    .onEnded { gesture in
                        gameViewModel.shoot(at: gesture.location)
                    }
            )
            .onTapGesture { gestureLocation in
                gameViewModel.adjustCannonAngle(point: gestureLocation)
                gameViewModel.shoot(at: gestureLocation)
            }
        }
    }

    private func boardView(boardSize: CGSize) -> some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .clipped()
            .edgesIgnoringSafeArea(.all)
            .frame(width: boardSize.width, height: boardSize.height)
    }

    private var cannonView: some View {
        Image(gameViewModel.gameEngine.isReadyToShoot ? "cannon-loaded" : "cannon-unloaded")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(gameViewModel.cannonAngle))
            .position(x: gameViewModel.boardSize.width / 2, y: 5)
    }

    private var pegsView: some View {
        let pegs = gameViewModel.pegs
        let removedPegs = gameViewModel.gameEngine.removedPegs

        let pegViewMap: [PegType: (PegGameObject) -> AnyView] = [
            .NormalPeg: { peg in AnyView(normalPegView(peg: peg)) },
            .GoalPeg: { peg in AnyView(goalPegView(peg: peg)) },
            .KaboomPeg: { peg in AnyView(kaboomPegView(peg: peg)) },
            .SpookyPeg: { peg in AnyView(spookyPegView(peg: peg)) },
            .StubbornPeg: { peg in AnyView(stubbornPegView(peg: peg)) },
            .HealthPeg: { peg in AnyView(healthPegView(peg: peg)) }
        ]

        return ForEach(pegs.indices, id: \.self) { index in
            let peg = pegs[index]
            let opacity: Double = removedPegs.contains(peg) ? 0.0 : 1.0
            pegViewMap[peg.pegtype]?(peg)
                .opacity(opacity)
                .animation(.easeOut(duration: 0.5), value: UUID())
        }
    }

    private func ballView(ball: BallGameObject) -> some View {
        Image("ball")
            .resizable()
            .scaledToFit()
            .frame(width: ball.diameter)
            .position(ball.position)
    }

    private func pegView(imageName: String, width: CGFloat, position: CGPoint) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .position(position)
    }

    private func normalPegView(peg: PegGameObject) -> some View {
        pegView(imageName: peg.isLit ? "peg-blue-glow" : "peg-blue", width: peg.diameter, position: peg.position)
    }

    private func goalPegView(peg: PegGameObject) -> some View {
        pegView(imageName: peg.isLit ? "peg-orange-glow" : "peg-orange", width: peg.diameter, position: peg.position)
    }

    private func kaboomPegView(peg: PegGameObject) -> some View {
        pegView(imageName: peg.isLit ? "peg-green-glow" : "peg-green", width: peg.diameter, position: peg.position)
    }

    private func spookyPegView(peg: PegGameObject) -> some View {
        pegView(imageName: peg.isLit ? "peg-purple-glow" : "peg-purple", width: peg.diameter, position: peg.position)
    }

    private func stubbornPegView(peg: PegGameObject) -> some View {
        pegView(imageName: peg.isLit ? "peg-grey-glow" : "peg-grey", width: peg.diameter, position: peg.position)
    }

    private func healthPegView(peg: PegGameObject) -> some View {
        let hitCountMap: [Int: String] = [
            1: "peg-yellow-glow",
            2: "peg-pink-glow",
            3: "peg-red"
        ]
        return pegView(imageName: hitCountMap[peg.hitCount] ?? "peg-yellow",
                       width: peg.diameter,
                       position: peg.position)
    }

    private var blocksView: some View {
        let blocks = gameViewModel.blocks

        return ForEach(blocks, id: \.self) { block in
            RoundedRectangle(cornerRadius: 10)
                .fill(.black)
                .frame(width: block.width, height: block.height)
                .rotationEffect(.degrees(block.rotation))
                .position(block.position)
        }
    }

    private var bucketView: some View {
        ImageView(imageName: "bucket")
            .frame(width: gameViewModel.bucket.width, height: gameViewModel.bucket.height)
            .position(gameViewModel.bucket.position)
    }
}

private struct StatsView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        VStack {
            topRowStatisticsView
            scoreView
        }

    }

    private var topRowStatisticsView: some View {
        HStack {
            backButtonView
            Spacer()
            pegStatisticsView
        }
    }

    private var backButtonView: some View {
        Button(action: {
            gameViewModel.end()
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(Circle())
                .padding(20)
        }
    }

    private var pegStatisticsView: some View {
        let pegMap: [PegType: String] = [
            .NormalPeg: "peg-blue",
            .GoalPeg: "peg-orange",
            .KaboomPeg: "peg-green",
            .SpookyPeg: "peg-purple",
            .HealthPeg: "peg-yellow",
            .StubbornPeg: "peg-grey"
        ]

        let pegTypes: [PegType] = [.NormalPeg, .GoalPeg, .KaboomPeg, .SpookyPeg, .HealthPeg, .StubbornPeg]

        return HStack(spacing: 10) {
            ForEach(pegTypes, id: \.self) { pegType in
                ZStack {
                    ImageView(imageName: pegMap[pegType] ?? "")
                        .frame(width: 75, height: 75)
                    Text("\(gameViewModel.pegsRemainingMap[pegType] ?? 0)")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(.black.opacity(0.7))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }

    private var scoreView: some View {
        HStack {
            Text("Score: \(gameViewModel.score)")
            Spacer()
            Text("Attempts left: \(gameViewModel.ballsRemaining)")
        }
        .foregroundColor(.white)
        .font(.headline)
        .padding(10)
        .background(.black.opacity(0.5))
        .cornerRadius(10)
        .padding(30)
    }
}

private struct ImageView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
    }
}
