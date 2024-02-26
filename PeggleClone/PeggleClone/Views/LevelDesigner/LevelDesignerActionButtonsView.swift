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
            loadView

            saveButtonView

            deleteButtonView

            resetButtonView

            startButtonView
        }
    }

    private var loadView: some View {
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
                    viewModel.loadGameboard(id: id)
                } else {
                    viewModel.newGameboard()
                }
            }
        }
    }

    private var saveButtonView: some View {
        ButtonView(title: "SAVE", tapAction: {
            if viewModel.hasMinOneGoalPeg {
                text = viewModel.gameboard.name
                isSavePresented.toggle()
            } else {
                showGoalPegAlert = true
            }
        })
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
        ButtonView(title: "DELETE", tapAction: {
            viewModel.deleteGameboard()
            selectedGameboard = nil
        })
    }

    private var resetButtonView: some View {
        ButtonView(title: "RESET", tapAction: {
            viewModel.reset()
        })
    }

    private var startButtonView: some View {
        ButtonView(title: "START", tapAction: {
            if viewModel.hasMinOneGoalPeg {
                isGameView = true
            } else {
                showGoalPegAlert = true
            }
        })
        .fullScreenCover(isPresented: $isGameView) {
            GameView(gameboard: viewModel.gameboard)
        }
        .alert(isPresented: $showGoalPegAlert) {
            Alert(title: Text("Error"),
                  message: Text("At least one goal peg is required."),
                  dismissButton: .default(Text("OK")))
        }
    }
}

private struct ButtonView: View {
    let title: String
    var tapAction: () -> Void

    var body: some View {
        Button(action: {
            tapAction()
        }) {
            Text(title).foregroundColor(.blue)
        }
    }
}
