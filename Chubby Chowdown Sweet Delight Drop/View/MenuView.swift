//
//  MenuView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @Binding var isShowingMenu: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Candy Catcher")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Start Game") {
                isShowingMenu = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
