//
//  GameOverView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

import SwiftUI

struct GameOverView: View {
    let score: Int
    let bestScore: Int
    let onRestart: () -> Void
    let onMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your Score: \(score)")
                .font(.title2)
            
            Text("Best Score: \(bestScore)")
                .font(.title2)
            
            HStack(spacing: 20) {
                Button("Restart") {
                    onRestart()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Menu") {
                    onMenu()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(20)
    }
}
