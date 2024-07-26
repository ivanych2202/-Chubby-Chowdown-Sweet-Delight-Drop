//
//  ContentView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingMenu = true
    @State private var isShowingLevelCollection = false
    @State private var isShowingGameView = false
    @State private var selectedLevel: Int?
    @State private var canContinue: Bool = false
    @State private var gameState: GameState?

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if isShowingMenu {
                MenuView(isShowingMenu: $isShowingMenu,
                         isShowingLevelCollection: $isShowingLevelCollection,
                         onContinue: {
                            isShowingMenu = false
                            isShowingGameView = true
                            gameState = GameDataManager.shared.loadGame()
                            print("Continuing game. Loaded state: \(gameState != nil)")
                         })
            }

            if isShowingLevelCollection {
                LevelCollectionView(
                    isShowingLevelCollection: $isShowingLevelCollection,
                    onSelectLevel: { level in
                        print("Selected level is \(level)")
                        selectedLevel = level
                        isShowingLevelCollection = false
                        isShowingGameView = true
                        isShowingMenu = false
                        gameState = nil // Start a new game
                    },
                    onMenu: {
                        isShowingLevelCollection = false
                        isShowingMenu = true
                    }
                )
                .transition(.move(edge: .bottom))
            }

            if isShowingGameView {
                GameView(isShowingMenu: $isShowingMenu,
                         isShowingGameView: $isShowingGameView,
                         canContinue: $canContinue,
                         gameState: $gameState)
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                if isShowingGameView {
                    GameDataManager.shared.saveGame(gameState)
                    print("Game state saved due to app becoming inactive")
                }

            }
        }
    }
}

