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
            SlidersView(viewModel: viewModel)
            ButtonsView(viewModel: viewModel)
        }
    }
}

private struct GameboardView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                boardView
                pegsView
                blocksView
            }
            .onAppear {
                viewModel.setBoardSize(newSize: geometry.size)
            }
            .onTapGesture { gestureLocation in
                guard !viewModel.isDelete else {
                    return
                }
                if viewModel.pegtype != nil {
                    viewModel.addPeg(at: gestureLocation)
                } else {
                    viewModel.addBlock(at: gestureLocation)
                }
            }
        }
    }

    private var boardView: some View {
        let boardSize = viewModel.gameboard.boardSize

        return ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .clipped()
                .edgesIgnoringSafeArea(.top)
                .frame(width: boardSize.width, height: boardSize.height)

            VStack {
                Spacer()
                Text("Restricted Bucket Area")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(Color.red.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
            }
        }
    }

    private var pegsView: some View {
        let pegs = viewModel.gameboard.pegs

        let pegViewMap: [PegType: () -> AnyView] = [
            .NormalPeg: { AnyView(ImageView(imageName: "peg-blue")) },
            .GoalPeg: { AnyView(ImageView(imageName: "peg-orange")) },
            .KaboomPeg: { AnyView(ImageView(imageName: "peg-green")) },
            .SpookyPeg: { AnyView(ImageView(imageName: "peg-purple")) },
            .StubbornPeg: { AnyView(ImageView(imageName: "peg-grey")) },
            .HealthPeg: { AnyView(ImageView(imageName: "peg-yellow")) }
        ]

        return ZStack {
            ForEach(pegs, id: \.self) { peg in
                pegViewMap[peg.pegtype]?()
                    .frame(width: peg.diameter)
                    .rotationEffect(.degrees(peg.rotation))
                    .position(peg.position)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                viewModel.movePeg(peg: peg, to: value.location)
                            })
                    )
                    .onTapGesture {
                        if viewModel.isDelete {
                            viewModel.deletePeg(peg: peg)
                            return
                        }
                        viewModel.setSelectedPeg(peg: peg)
                    }
                    .onLongPressGesture(minimumDuration: 1.0) {
                        viewModel.deletePeg(peg: peg)
                    }

                if viewModel.selectedPeg == peg {
                    Circle()
                        .stroke(.red, lineWidth: 2)
                        .frame(width: peg.diameter + 10, height: peg.diameter + 10)
                        .position(peg.position)
                }
            }
        }
    }

    private var blocksView: some View {
        let blocks = viewModel.gameboard.blocks

        return ZStack {
            ForEach(blocks, id: \.self) { block in
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black)
                    .frame(width: block.width, height: block.height)
                    .rotationEffect(.degrees(block.rotation))
                    .position(block.position)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                viewModel.moveBlock(block: block, to: value.location)
                            })
                    )
                    .onTapGesture {
                        if viewModel.isDelete {
                            viewModel.deleteBlock(block: block)
                            return
                        }
                        viewModel.setSelectedBlock(block: block)
                    }
                    .onLongPressGesture(minimumDuration: 1.0) {
                        viewModel.deleteBlock(block: block)
                    }

                if viewModel.selectedBlock == block {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: block.width + 10, height: block.height + 10)
                        .rotationEffect(.degrees(block.rotation))
                        .position(block.position)
                }
            }
        }
    }
}

private struct SlidersView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        HStack {
            backButtonView
            Spacer()
            VStack {
                HStack {
                    rotationSlider
                    diameterSlider
                }
                HStack {
                    heightSlider
                    widthSlider
                }
            }

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
             .padding(.horizontal)
        }
    }

    private var diameterSlider: some View {
        HStack {
            Text("Diameter")
            Slider(value: Binding<Double>(
                get: {
                    if let diameter = self.viewModel.selectedPeg?.diameter {
                        return diameter
                    }
                    return Peg.DEFAULT_PEG_DIAMETER
                },
                set: { newValue in
                    if self.viewModel.selectedPeg != nil {
                        viewModel.resizePeg(newDiameter: newValue)
                    }
                }
            ), in: Peg.DEFAULT_PEG_DIAMETER...Peg.DEFAULT_PEG_DIAMETER * 4, step: 1)
            .padding(.horizontal)
        }
        .opacity((viewModel.selectedPeg != nil) ? 1 : 0.2)
        .disabled(viewModel.selectedPeg == nil)
    }

    private var rotationSlider: some View {
        HStack {
            Text("Rotation")
            Slider(value: Binding<Double>(
                get: {
                    if let selectedPeg = self.viewModel.selectedPeg {
                        return selectedPeg.rotation
                    } else if let selectedBlock = self.viewModel.selectedBlock {
                        return selectedBlock.rotation
                    }
                    return 0
                },
                set: { newValue in
                    if self.viewModel.selectedPeg != nil {
                        viewModel.rotatePeg(newAngle: newValue)
                    } else if self.viewModel.selectedBlock != nil {
                        viewModel.rotateBlock(newAngle: newValue)
                    }
                }
            ), in: 0...360, step: 1)
            .padding(.horizontal)
        }
        .opacity((viewModel.selectedPeg == nil && viewModel.selectedBlock == nil) ? 0.2 : 1)
        .disabled(viewModel.selectedPeg == nil && viewModel.selectedBlock == nil)
    }

    private var heightSlider: some View {
        HStack {
            Text("Height")
            Slider(value: Binding<Double>(
                get: {
                    if let height = self.viewModel.selectedBlock?.height {
                        return height
                    }
                    return Block.DEFAULT_BLOCK_HEIGHT
                },
                set: { newValue in
                    if self.viewModel.selectedBlock != nil {
                        viewModel.resizeBlockHeight(newHeight: newValue)
                    }
                }
            ), in: Block.DEFAULT_BLOCK_HEIGHT...Block.DEFAULT_BLOCK_HEIGHT * 4, step: 1)
            .padding(.horizontal)
        }
        .opacity((viewModel.selectedBlock != nil) ? 1 : 0.2)
        .disabled(viewModel.selectedBlock == nil)
    }

    private var widthSlider: some View {
        HStack {
            Text("Width")
            Slider(value: Binding<Double>(
                get: {
                    if let width = self.viewModel.selectedBlock?.width {
                        return width
                    }
                    return Block.DEFAULT_BLOCK_WIDTH
                },
                set: { newValue in
                    if self.viewModel.selectedBlock != nil {
                        viewModel.resizeBlockWidth(newWidth: newValue)
                    }
                }
            ), in: Block.DEFAULT_BLOCK_WIDTH...Block.DEFAULT_BLOCK_WIDTH * 4, step: 1)
            .padding(.horizontal)
        }
        .opacity((viewModel.selectedBlock != nil) ? 1 : 0.2)
        .disabled(viewModel.selectedBlock == nil)
    }
}

private struct ButtonsView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    var body: some View {
        let pegMap: [PegType: String] = [
            .NormalPeg: "peg-blue",
            .GoalPeg: "peg-orange",
            .KaboomPeg: "peg-green",
            .SpookyPeg: "peg-purple",
            .HealthPeg: "peg-yellow",
            .StubbornPeg: "peg-grey"
        ]

        let pegTypes: [PegType] = [.NormalPeg, .GoalPeg, .KaboomPeg, .SpookyPeg, .HealthPeg, .StubbornPeg]

        let pegCountMap = viewModel.pegsCountByType

        return HStack {
            ForEach(pegTypes, id: \.self) { pegType in
                Button(action: {
                    viewModel.setPegType(pegtype: pegType)
                }) {
                    ZStack {
                        ImageView(imageName: pegMap[pegType] ?? "")
                            .opacity(viewModel.pegtype == pegType ? 1.0 : 0.5)
                            .frame(width: 75, height: 75)
                        Text("\(pegCountMap[pegType] ?? 0)")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
            }
            blockButton
            Spacer()
            deleteButton
        }
        .padding()
    }

    private var blockButton: some View {
        Button(action: {
            viewModel.setPegType(pegtype: nil)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black)
                    .frame(width: 40, height: 75)
                    .opacity(viewModel.pegtype == nil ? 1.0 : 0.5)
                Text("\(viewModel.gameboard.blocks.count)")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white.opacity(0.7))
                    .clipShape(Circle())
            }
        }
    }

    private var deleteButton: some View {
        Button(action: {
            viewModel.toggleIsDelete()
        }) {
            ImageView(imageName: "delete")
                .opacity(viewModel.isDelete ? 1.0 : 0.5)
                .frame(width: 75)
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
