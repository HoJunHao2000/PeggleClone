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
                    selectedGameboard = viewModel.gameboard.id
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
