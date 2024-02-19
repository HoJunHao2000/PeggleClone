//
//  LevelDesignerView.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 24/1/24.
//

import SwiftUI

struct LevelDesignerView: View {
    @ObservedObject var viewModel = LevelDesigner()

    var body: some View {
        VStack {
            LevelDesignerBoardView(viewModel: viewModel)
            LevelDesignerActionButtonsView(viewModel: viewModel)
        }
        .ignoresSafeArea(.keyboard)
    }
}
