//
//  Chubby_Chowdown_Sweet_Delight_DropApp.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 02.04.2024.
//

import SwiftUI

@main
struct Chubby_Chowdown_Sweet_Delight_DropApp: App {
    
    init() {
        SoundManager.shared.preloadSound("eat")
        SoundManager.shared.preloadSound("button")
        SoundManager.shared.preloadSound("gameover")
        SoundManager.shared.preloadSound("highscore")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
