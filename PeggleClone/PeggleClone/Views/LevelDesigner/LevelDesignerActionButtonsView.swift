//
//  LevelDesignerActionButtons.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/1/24.
//

import SwiftUI

struct LevelDesignerActionButtonsView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel

    @State private var text: String = ""
    @State private var isSavePresented = false
    @State private var isLoadPresented = false
    @State private var selectedGameboard: UUID?
    @State private var isGameView = false
    @State private var showGoalPegAlert = false

    var body: some View {
        HStack {
            loadButtonView
            saveButtonView
            deleteButtonView
            resetButtonView
            startButtonView
        }
    }

    private var loadButtonView: some View {
        Menu("LOAD") {
            Picker("Current Gameboard", selection: $selectedGameboard) {
                Text("New Gameboard")
                    .tag(UUID?.none)
                ForEach(viewModel.gameboards, id: \.self) { gameboardEntity in
                    if let id = gameboardEntity.id, let name = gameboardEntity.name {
                        Text(name)
                            .tag(UUID?.some(id))
                    }
                }
            }
            .onChange(of: selectedGameboard) {
                if let id = selectedGameboard {
                    viewModel.loadGameboard(id: id, preloadId: -1)
                } else {
                    viewModel.newGameboard()
                }
            }

            Section {
                ForEach(1...3, id: \.self) { index in
                    Button("Preloaded \(index)") {
                        viewModel.loadGameboard(id: UUID(), preloadId: index)
                    }
                }
            }
        }
    }

    private var saveButtonView: some View {
        Button("SAVE") {
            if viewModel.hasMinOneGoalPeg {
                text = viewModel.gameboard.name
                isSavePresented.toggle()
            } else {
                showGoalPegAlert = true
            }
        }
        .alert("SAVE", isPresented: $isSavePresented) {
            TextField("Name of level", text: $text)
            Button("OK", action: {
                viewModel.saveGameboard(name: text.isEmpty ? viewModel.gameboard.name : text)
                selectedGameboard = viewModel.gameboard.id
            })
            Button("Cancel", role: .cancel) {
                isSavePresented = false
            }
        }
        .alert(isPresented: $showGoalPegAlert) {
            Alert(title: Text("Error"),
                  message: Text("At least one goal peg is required."),
                  dismissButton: .default(Text("OK")))
        }
    }

    private var deleteButtonView: some View {
        Button("DELETE") {
            viewModel.deleteGameboard()
            selectedGameboard = nil
        }
    }

    private var resetButtonView: some View {
        Button("RESET") {
            viewModel.reset()
        }
    }

    private var startButtonView: some View {
        Button("START") {
            if viewModel.hasMinOneGoalPeg {
                isGameView = true
            } else {
                showGoalPegAlert = true
            }
        }
        .fullScreenCover(isPresented: $isGameView) {
            GameView(gameboard: viewModel.gameboard)
        }
        .alert(isPresented: $showGoalPegAlert) {
            Alert(
                title: Text("Error"),
                message: Text("At least one goal peg is required."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
