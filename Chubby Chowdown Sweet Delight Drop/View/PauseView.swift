//
//  PauseView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

import SwiftUI

struct PauseView: View {
    let currentScore: Int
    let bestScore: Int
    let onResume: () -> Void
    let onMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pause")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Current Score: \(currentScore)")
                .font(.title2)
            
            Text("Best Score: \(bestScore)")
                .font(.title2)
            
            HStack(spacing: 20) {
                Button("Resume") {
                    onResume()
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
