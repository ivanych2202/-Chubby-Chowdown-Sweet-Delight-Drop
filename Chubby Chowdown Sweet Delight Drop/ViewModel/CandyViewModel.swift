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
        isPaused = false
    }
    
    func updateGameState() {
        if !isPaused && !isGameOver {
            updateCandyPositions()
            spawnNewCandy()
        }
    }
    
    func pauseGame() {
        isPaused = true
        timer?.invalidate()
    }
    
    func resumeGame() {
        isPaused = false
        startCandySpawner()
    }
    
    private func startCandySpawner() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updateGameState()
        }
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
        checkGameOver()
    }

    private func checkGameOver() {
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
        GameDataManager.shared.clearSavedGame()
    }
    
    func loadState(_ state: CandyState) {
        self.candies = state.candies
        self.score = state.score
        self.isGameOver = state.isGameOver
        self.isPaused = true // Загруженная игра должна быть на паузе
    }
    
    func checkCollisionsAndRemove(characterFrame: CGRect, onCollision: @escaping (CandyModel) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            var collidedCandies: [CandyModel] = []
            var newScore = self.score
            
            for candy in self.candies {
                let candyFrame = CGRect(x: candy.position.x - 25,
                                        y: candy.position.y - 25,
                                        width: 50, height: 50)
                
                if characterFrame.intersects(candyFrame) {
                    collidedCandies.append(candy)
                    newScore += 1
                    DispatchQueue.main.async {
                        onCollision(candy)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.candies.removeAll { candy in
                    collidedCandies.contains { $0.id == candy.id }
                }
                self.score = newScore
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
