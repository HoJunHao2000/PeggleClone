//
//  LevelDesignerActionButtons.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/1/24.
//

import SwiftUI

struct LevelDesignerActionButtonsView: View {
    @ObservedObject var viewModel: LevelDesigner

    @State private var text: String = ""
    @State private var isSavePresented = false
    @State private var isLoadPresented = false
    @State private var selectedGameboard: GameboardEntity?

    var body: some View {
        HStack {
            LoadMenu

            ButtonView(title: "SAVE", tapAction: {
                text = viewModel.gameboard.name
                isSavePresented.toggle()
            })
            .alert("SAVE", isPresented: $isSavePresented) {
                TextField("Name of level", text: $text)
                Button("OK", action: {
                    viewModel.saveGameboard(name: text.isEmpty ? viewModel.gameboard.name : text)
                })
                Button("Cancel", role: .cancel) {
                    isSavePresented = false
                }
            }

            ButtonView(title: "DELETE", tapAction: {
                viewModel.deleteGameboard()
                selectedGameboard = nil
            })

            ButtonView(title: "RESET", tapAction: {
                viewModel.reset()
            })

            ButtonView(title: "START", tapAction: {
                // Your action for the START button
            })
        }
    }

    private var LoadMenu: some View {
        Menu("LOAD") {
            Picker("Current Gameboard", selection: $selectedGameboard) {
                Text("New Gameboard")
                    .tag(GameboardEntity?.none)
                ForEach(viewModel.getGameboards(), id: \.id) { gameboardEntity in
                    if let name = gameboardEntity.name {
                        Text(name)
                            .tag(GameboardEntity?.some(gameboardEntity))
                    }
                }
            }
            .onChange(of: selectedGameboard) {
                if let id = selectedGameboard?.id {
                    viewModel.loadGameboard(id: id)
                } else {
                    viewModel.newGameboard()
                }
            }
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
