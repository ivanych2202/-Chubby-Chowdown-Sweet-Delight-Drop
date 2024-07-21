//
//  ContentView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingMenu = true
    
    var body: some View {
        if isShowingMenu {
            MenuView(isShowingMenu: $isShowingMenu)
 
        } else {
            GameView(isShowingMenu: $isShowingMenu)
                .onAppear {
                    SoundManager.shared.playBackgroundMusic("bgm\(Int.random(in: 1...6))")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}

