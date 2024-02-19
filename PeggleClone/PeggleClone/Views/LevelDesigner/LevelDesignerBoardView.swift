//
//  LevelDesignerBoardView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/1/24.
//

import SwiftUI

struct LevelDesignerBoardView: View {
    @ObservedObject var viewModel: LevelDesigner

    var body: some View {
        VStack {
            GameboardView(viewModel: viewModel)
            ButtonsView(viewModel: viewModel)
        }
    }
}

private struct GameboardView: View {
    @ObservedObject var viewModel: LevelDesigner

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
    @ObservedObject var viewModel: LevelDesigner

    var body: some View {
        let gameboard = viewModel.gameboard

        ForEach(gameboard.pegs.indices, id: \.self) { index in
            PegView(position: gameboard.pegs[index].position, isBlue: gameboard.pegs[index].isBlue)
                .onTapGesture {
                    if viewModel.isDelete {
                        deletePeg(at: index)
                    }
                }
                .onLongPressGesture(minimumDuration: 1.0) {
                    deletePeg(at: index)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            viewModel.movePeg(at: index, to: value.location)
                        })
                )
        }
    }

    private func deletePeg(at index: Int) {
        viewModel.deletePeg(at: index)
    }
}

private struct ButtonsView: View {
    @ObservedObject var viewModel: LevelDesigner

    var body: some View {
        HStack {
            ButtonView(imageName: "peg-blue", tapAction: {
                viewModel.setIsBlue(isBlue: true)
            })
            .opacity(buttonOpacity(true))

            ButtonView(imageName: "peg-orange", tapAction: {
                viewModel.setIsBlue(isBlue: false)
            })
            .opacity(buttonOpacity(false))

            Spacer()

            ButtonView(imageName: "delete", tapAction: {
                viewModel.toggleIsDelete()
            })
        }
    }

    private func buttonOpacity(_ buttonIsBlue: Bool) -> Double {
        viewModel.isDelete ? 0.5 : viewModel.isBlue == buttonIsBlue ? 1.0 : 0.5
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

private struct ButtonView: View {
    var imageName: String
    var tapAction: () -> Void

    var body: some View {
        Button(action: {
            tapAction()
        }) {
            ImageView(imageName: imageName)
                .frame(width: 100)
        }
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
