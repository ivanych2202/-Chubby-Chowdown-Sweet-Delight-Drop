//
//  MenuView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

import SwiftUI

struct MenuView: View {
    @Binding var isShowingMenu: Bool
    @Binding var isShowingLevelCollection: Bool
    let onContinue: () -> Void
    
    @State private var canContinue: Bool = false
    
    var body: some View {
        VStack {
            Text("Main Menu")
                .font(.largeTitle)
                .padding()
            
            if canContinue {
                Button("Continue") {
                    onContinue()
                }

                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Exit") {
                    isShowingMenu = false
                    canContinue = false
                    GameDataManager.shared.clearSavedGame()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button("Select Level") {
                isShowingLevelCollection = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // Add more buttons as needed
        }
        .onAppear {
            canContinue = GameDataManager.shared.hasSavedGame()
        }

    }
    
    private func checkForSavedGame() {
        canContinue = GameDataManager.shared.hasSavedGame()
    }
}

