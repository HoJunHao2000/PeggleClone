//
//  GameView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var gameViewModel: GameViewModel

    init(gameboard: Gameboard) {
        self.gameViewModel = GameViewModel(gameboard: gameboard)
    }

    var body: some View {
        VStack {
            gameLevelView
            statsView
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
    }

    private var gameLevelView: some View {
        ZStack {
            boardView
            cannonView
            pegsView
            if let ball = gameViewModel.ball {
                ballView(ball: ball)
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

    private var boardView: some View {
        let boardSize = gameViewModel.boardSize

        return Image("background")
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

        let pegViewMap: [PegType: (CGFloat, CGPoint, Bool) -> AnyView] = [
            .NormalPeg: { width, position, isLit in AnyView(normalPegView(width: width,
                                                                          position: position,
                                                                          isLit: isLit)) },
            .GoalPeg: { width, position, isLit in AnyView(goalPegView(width: width,
                                                                      position: position,
                                                                      isLit: isLit)) },
            .PowerUpPeg: { width, position, isLit in AnyView(powerUpPegView(width: width,
                                                                            position: position,
                                                                            isLit: isLit)) },
            .StubbornPeg: { width, position, isLit in AnyView(stubbornPegView(width: width,
                                                                              position: position,
                                                                              isLit: isLit)) },
            .HealthPeg: { width, position, isLit in AnyView(healthPegView(width: width,
                                                                          position: position,
                                                                          isLit: isLit)) }
        ]

        return ForEach(pegs.indices, id: \.self) { index in
            let peg = pegs[index]
            let opacity: Double = removedPegs.contains(peg) ? 0.0 : 1.0
            pegViewMap[peg.pegtype]?(peg.diameter, peg.position, peg.isLit)
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

    private func normalPegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-blue-glow" : "peg-blue", width: width, position: position)
    }

    private func goalPegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-orange-glow" : "peg-orange", width: width, position: position)
    }

    private func powerUpPegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-green-glow" : "peg-green", width: width, position: position)
    }

    private func stubbornPegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-grey-glow" : "peg-grey", width: width, position: position)
    }

    private func healthPegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-yellow-glow" : "peg-yellow", width: width, position: position)
    }

    private var statsView: some View {
        VStack {
            topRowStatisticsView
            Spacer()
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
            .PowerUpPeg: "peg-green",
            .HealthPeg: "peg-yellow",
            .StubbornPeg: "peg-grey"
        ]

        let pegTypes: [PegType] = [.NormalPeg, .GoalPeg, .PowerUpPeg, .HealthPeg, .StubbornPeg]

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
        .padding(10)
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
