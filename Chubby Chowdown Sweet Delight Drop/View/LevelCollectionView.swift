//
//  LevelCollectionView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 26.07.2024.
//

import SwiftUI

struct LevelCollectionView: View {
    @Binding var isShowingLevelCollection: Bool
    let onSelectLevel: (Int) -> Void
    let onMenu: () -> Void

    var body: some View {
        VStack {
            Text("Select Level")
                .font(.largeTitle)
                .padding()

            ForEach(1...5, id: \.self) { level in
                Button("Level \(level)") {
                    onSelectLevel(level)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Button("Back to Menu") {
                onMenu()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(20)
    }
}
