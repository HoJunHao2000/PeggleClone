//
//  GameView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 9/2/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        ZStack {
            boardView
            cannonView
            pegsView
            scoreView
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

    private var scoreView: some View {
        HStack {
            Spacer()
            VStack {
                VStack(alignment: .leading) {
                    Text("Score: \(gameViewModel.score)")
                    Text("Balls Left: \(gameViewModel.ballsRemaining)")
                }
                .foregroundColor(.white)
                .font(.headline)
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(10)
                Spacer()
            }
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
        Image("cannon")
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
            .NormalPeg: { width, position, isLit in AnyView(bluePegView(width: width,
                                                                        position: position,
                                                                        isLit: isLit)) },
            .GoalPeg: { width, position, isLit in AnyView(orangePegView(width: width,
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

    private func bluePegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-blue-glow" : "peg-blue", width: width, position: position)
    }

    private func orangePegView(width: CGFloat, position: CGPoint, isLit: Bool) -> some View {
        pegView(imageName: isLit ? "peg-orange-glow" : "peg-orange", width: width, position: position)
    }
}
