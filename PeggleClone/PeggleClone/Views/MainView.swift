//
//  MainView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/2/24.
//

import SwiftUI

struct MainView: View {
    @State private var isLevelSelectorView = false
    @State private var isLevelDesignerView = false

    var body: some View {
        ZStack {
            backgroundView
            menuOptionsView
        }
        .onAppear {
            SoundManager.instance.playSound(.main, isLoop: true)
        }
    }

    private var backgroundView: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }

    private var menuOptionsView: some View {
        VStack {
            Text("PeggleClone")
                .font(.system(size: 60))
                .padding()

            playButtonView

            levelDesignerButtonView
        }
    }

    private var playButtonView: some View {
        Button(action: {
            SoundManager.instance.playSound(.click)
            isLevelSelectorView = true
            isLevelDesignerView = false
        }) {
            Text("Play")
                .font(.system(size: 35))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.black, lineWidth: 5)
                        .background(.green)
                )
                .foregroundColor(.black)
                .cornerRadius(30)
                .padding()
        }
        .fullScreenCover(isPresented: $isLevelSelectorView) {
            LevelSelectorView()
        }
    }

    private var levelDesignerButtonView: some View {
        Button(action: {
            SoundManager.instance.stopSound(.main)
            SoundManager.instance.playSound(.click)
            isLevelSelectorView = false
            isLevelDesignerView = true
        }) {
            Text("Level Designer")
                .font(.system(size: 35))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.black, lineWidth: 5)
                        .background(.yellow)
                )
                .foregroundColor(.black)
                .cornerRadius(30)
                .padding()
        }
        .fullScreenCover(isPresented: $isLevelDesignerView) {
            LevelDesignerView()
        }
    }
}
