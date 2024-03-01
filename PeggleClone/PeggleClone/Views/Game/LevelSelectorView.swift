//
//  LevelSelectorView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/2/24.
//

import SwiftUI

struct LevelSelectorView: View {
    @Environment(\.dismiss) var dismiss

    @State private var gameboards: [Gameboard] = []
    @State private var isGameView: [Bool] = []

    let viewModel = LevelSelectorViewModel()

    var body: some View {
        ZStack {
            backgroundView
            backButtonView
            levelsView
        }
        .onAppear {
            gameboards = viewModel.gameboards
            isGameView = Array(repeating: false, count: gameboards.count + 3)
        }
    }

    private var backgroundView: some View {
        GeometryReader { _ in
            Image("background")
                .resizable()
                .scaledToFill()
                .clipped()
                .edgesIgnoringSafeArea(.all)
        }
    }

    private var levelsView: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.7
            let height = geometry.size.height * 0.7

            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(gameboards.enumerated()), id: \.element.id) { index, gameboard in
                        levelRowView(gameboard: gameboard, index: index)
                    }
                }
            }
            .frame(width: width, height: height)
            .padding()
            .background(.white.opacity(0.8))
            .cornerRadius(20)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }

    private func levelRowView(gameboard: Gameboard, index: Int) -> some View {
        Button(action: {
            SoundManager.instance.stopSound(.main)
            SoundManager.instance.playSound(.click)
            isGameView[index] = true
        }) {
            Text(gameboard.name)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.2))
                .cornerRadius(20)
        }
        .fullScreenCover(isPresented: $isGameView[index]) {
            if index < 3 {
                GameView(preload: index + 1)
            } else {
                GameView(gameboard: gameboard)
            }
        }

    }

    private var backButtonView: some View {
        VStack {
            HStack {
                Button(action: {
                    SoundManager.instance.playSound(.click)
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                        .background(.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(20)
                }
                Spacer()
            }
            Spacer()
        }
    }
}
