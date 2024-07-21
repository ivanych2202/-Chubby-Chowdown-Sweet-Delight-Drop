//
//  CandyViewModel.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

// CandyViewModel.swift
import Foundation
import Combine

class CandyViewModel: ObservableObject {
    @Published var candies: [CandyModel] = []
    @Published var score: Int = 0
    @Published var bestScore: Int = UserDefaults.standard.integer(forKey: "BestScore")
    @Published var isGameOver: Bool = false
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    private let screenHeight: CGFloat
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat, screenHeight: CGFloat) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }
    
    func startGame() {
        resetGame()
        startCandySpawner()
    }
    
    func resetGame() {
        candies.removeAll()
        score = 0
        isGameOver = false
    }
    
    func updateGameState() {
        if !isPaused {
            updateCandyPositions()
            spawnNewCandy()
            
        }
    }
    
    func pauseGame() {
        isPaused = true
    }
    
    func resumeGame() {
        isPaused = false
    }
    
    private func startCandySpawner() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updateGameState()
        }
    }
    
    func removeCandy(_ candy: CandyModel) {
        candies.removeAll { $0.id == candy.id }
    }
    
    private func spawnNewCandy() {
        if Double.random(in: 0...1) < 0.02 {
            candies.append(CandyModel(screenWidth: screenWidth))
        }
    }
    
     func updateCandyPositions() {
        for i in 0..<candies.count {
            candies[i].position.y += candies[i].speed * 0.05
        }
        if candies.contains(where: { $0.position.y > screenHeight + 100 }) {
            gameOver()
        }
        candies.removeAll { $0.position.y > screenHeight + 100 }
    }

    private func gameOver() {
        isGameOver = true
        timer?.invalidate()
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "BestScore")
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
