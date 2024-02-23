//
//  LevelDesignerBoardView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/1/24.
//

import SwiftUI

struct LevelDesignerBoardView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        VStack {
            GameboardView(viewModel: viewModel)
            ButtonsView(viewModel: viewModel)
        }
    }
}

private struct GameboardView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BoardView(boardSize: geometry.size)
                PegsView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.setBoardSize(newSize: geometry.size)
            }
            .onTapGesture { gestureLocation in
                guard !viewModel.isDelete else {
                    return
                }
                viewModel.addPeg(at: gestureLocation)
            }
        }
    }
}

private struct BoardView: View {
    let boardSize: CGSize

    var body: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .clipped()
            .edgesIgnoringSafeArea(.top)
            .frame(width: boardSize.width, height: boardSize.height)
    }
}

private struct PegsView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        let pegs = viewModel.gameboard.pegs

        let pegViewMap: [PegType: (Double, CGPoint, Double) -> AnyView] = [
            .NormalPeg: { width, position, rotation in AnyView(normalPegView(width: width,
                                                                             position: position,
                                                                             rotation: rotation)) },
            .GoalPeg: { width, position, rotation in AnyView(goalPegView(width: width,
                                                                         position: position,
                                                                         rotation: rotation)) }
        ]

        ForEach(pegs, id: \.self) { peg in
            pegViewMap[peg.pegtype]?(peg.diameter, peg.position, peg.rotation)
                .onTapGesture {
                    if viewModel.isDelete {
                        viewModel.deletePeg(peg: peg)
                    }
                }
                .onLongPressGesture(minimumDuration: 1.0) {
                    viewModel.deletePeg(peg: peg)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            viewModel.movePeg(peg: peg, to: value.location)
                        })
                )
        }
    }

    private func normalPegView(width: Double, position: CGPoint, rotation: Double) -> some View {
        ImageView(imageName: "peg-blue")
            .frame(width: width)
            .rotationEffect(.degrees(rotation))
            .position(position)
    }

    private func goalPegView(width: Double, position: CGPoint, rotation: Double) -> some View {
        ImageView(imageName: "peg-orange")
            .frame(width: width)
            .rotationEffect(.degrees(rotation))
            .position(position)
    }
}

private struct ButtonsView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.setPegType(pegtype: .NormalPeg)
            }) {
                ImageView(imageName: "peg-blue")
                    .opacity(viewModel.pegtype == .NormalPeg ? 1.0 : 0.5)
                    .frame(width: 75)
            }

            Button(action: {
                viewModel.setPegType(pegtype: .GoalPeg)
            }) {
                ImageView(imageName: "peg-orange")
                    .opacity(viewModel.pegtype == .GoalPeg ? 1.0 : 0.5)
                    .frame(width: 75)
            }

            Spacer()

            Button(action: {
                viewModel.toggleIsDelete()
            }) {
                ImageView(imageName: "delete")
                    .opacity(viewModel.isDelete ? 1.0 : 0.5)
                    .frame(width: 75)
            }
        }
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

private struct PegView: View {
    var position: CGPoint
    let isBlue: Bool

    var body: some View {
        ImageView(imageName: isBlue ? "peg-blue" : "peg-orange")
            .frame(width: 50)
            .position(position)
    }
}
