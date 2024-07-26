//
//  GameDataManager.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 26.07.2024.
//

import Foundation

class GameDataManager {
    static let shared = GameDataManager()
    private let saveKey = "savedGameState"

    private init() {}

    func saveGame(_ gameState: GameState?) {
        guard let gameState = gameState else {
            print("Attempted to save nil game state")
            return
        }
        
        do {
            let encodedData = try JSONEncoder().encode(gameState)
            UserDefaults.standard.set(encodedData, forKey: saveKey)
            print("Game saved to UserDefaults. Score: \(gameState.candyState.score), Candies: \(gameState.candyState.candies.count)")
        } catch {
            print("Failed to save game state: \(error.localizedDescription)")
        }
    }
    
    func loadGame() -> GameState? {
        guard let savedData = UserDefaults.standard.data(forKey: saveKey) else {
            print("No saved game found in UserDefaults")
            return nil
        }
        
        do {
            let decodedGameState = try JSONDecoder().decode(GameState.self, from: savedData)
            print("Game loaded from UserDefaults. Score: \(decodedGameState.candyState.score), Candies: \(decodedGameState.candyState.candies.count)")
            return decodedGameState
        } catch {
            print("Failed to load game state: \(error.localizedDescription)")
            return nil
        }
    }

    func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: saveKey)
        print("Saved game cleared from UserDefaults")
    }

    func hasSavedGame() -> Bool {
        let hasSavedGame = UserDefaults.standard.data(forKey: saveKey) != nil
        print("Has saved game: \(hasSavedGame)")
        return hasSavedGame
    }
}
