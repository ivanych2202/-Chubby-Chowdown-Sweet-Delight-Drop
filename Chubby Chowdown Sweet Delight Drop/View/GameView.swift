//
//  GameView.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

// GameView.swift
import SwiftUI
import Lottie

struct GameView: View {
    @StateObject private var characterViewModel: CharacterViewModel
    @StateObject private var candyViewModel: CandyViewModel
    @Binding var isShowingMenu: Bool
    @Binding var isShowingGameView: Bool
    @Binding var canContinue: Bool
    @Binding var gameState: GameState?
    @State private var isShowingGameOver: Bool = false
    @State private var isShowingPause: Bool = false
    @State private var gameLoopTimer: Timer?
    @State private var isEating: Bool = false

    init(isShowingMenu: Binding<Bool>, isShowingGameView: Binding<Bool>, canContinue: Binding<Bool>, gameState: Binding<GameState?>) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        _characterViewModel = StateObject(wrappedValue: CharacterViewModel(screenWidth: screenWidth))
        _candyViewModel = StateObject(wrappedValue: CandyViewModel(screenWidth: screenWidth, screenHeight: screenHeight))
        _isShowingMenu = isShowingMenu
        _isShowingGameView = isShowingGameView
        _canContinue = canContinue
        _gameState = gameState
    }

    var body: some View {
        ZStack {
            LottieView(animation: .named("background"))
                .playing(loopMode: .loop)
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)

            LottieView(animation: .named(characterViewModel.animationName))
                .playing(loopMode: isEating ? .playOnce : .loop)
                .frame(width: 100, height: 100)
                .position(
                    x: characterViewModel.model.position,
                    y: UIScreen.main.bounds.height - 120
                )
                .onChange(of: isEating) { newValue in
                    if !newValue {
                        characterViewModel.stopEating()
                    }
                }

            ForEach(candyViewModel.candies) { candy in
                LottieView(animation: .named(candy.animationName))
                    .playing(loopMode: .loop)
                    .frame(width: 50, height: 50)
                    .position(candy.position)
            }

            VStack {
                HStack {
                    Button(action: {
                        pauseGame()
                    }) {
                        Image(systemName: "pause.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()

                    Spacer()

                    Text("Score: \(candyViewModel.score)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                }
                .padding(.top)

                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isEating && !candyViewModel.isGameOver && !isShowingPause {
                        characterViewModel.model.isDragging = true
                        characterViewModel.updateTargetPosition(value.location.x)
                    }
                }
                .onEnded { _ in
                    characterViewModel.model.isDragging = false
                }
        )
        .onAppear {
            if let _ = gameState {
                loadGame()
            } else {
                startNewGame()
            }
            SoundManager.shared.playBackgroundMusic("bgm\(Int.random(in: 1...6))")
        }
        .onDisappear {
            saveGame()
        }
        .overlay(
            Group {
                if isShowingGameOver {
                    GameOverView(
                        score: candyViewModel.score,
                        bestScore: candyViewModel.bestScore,
                        onRestart: {
                            restartGame()
                        },
                        onMenu: {
                            isShowingGameOver = false
                            isShowingGameView = false
                            isShowingMenu = true
                            canContinue = false
                            GameDataManager.shared.clearSavedGame()
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: isShowingGameOver)
                } else if isShowingPause {
                    PauseView(
                        currentScore: candyViewModel.score,
                        bestScore: candyViewModel.bestScore,
                        onResume: {
                            resumeGame()
                        },
                        onMenu: {
                            isShowingPause = false
                            isShowingGameView = false
                            isShowingMenu = true
                            canContinue = true
                            saveGame()
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: isShowingPause)
                }
            }
        )
    }


    private func startNewGame() {
        candyViewModel.resetGame()
        characterViewModel.resetPosition()
        resumeGameLoop()
    }

    private func resumeGameLoop() {
        gameLoopTimer?.invalidate()
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if self.candyViewModel.isGameOver {
                self.gameLoopTimer?.invalidate()
                SoundManager.shared.pauseBackgroundMusic()
                DispatchQueue.main.async {
                    self.isShowingGameOver = true
                }
                return
            }

            if !self.isEating && !self.isShowingPause {
                self.characterViewModel.updatePosition()
                self.checkCollisions()
            }
        }
        candyViewModel.resumeGame()
    }
    private func pauseGame() {
        SoundManager.shared.pauseBackgroundMusic()
        isShowingPause = true
        candyViewModel.pauseGame()
        saveGame()
    }

    private func resumeGame() {
        SoundManager.shared.resumeBackgroundMusic()
        isShowingPause = false
        candyViewModel.resumeGame()
    }

    private func restartGame() {
        SoundManager.shared.playBackgroundMusic("bgm\(Int.random(in: 1...6))")
        isShowingGameOver = false
        gameState = nil
        startNewGame()
        canContinue = false
    }
    
    private func gameOver() {
        isShowingGameOver = true
        gameState = nil
        GameDataManager.shared.clearSavedGame()
        canContinue = false
    }


    private func saveGame() {
        if !candyViewModel.isGameOver {
            let candyState = CandyState(
                candies: candyViewModel.candies,
                score: candyViewModel.score,
                isGameOver: candyViewModel.isGameOver
            )
            gameState = GameState(candyState: candyState)
            GameDataManager.shared.saveGame(gameState)
            print("Game saved. Score: \(candyViewModel.score), Candies: \(candyViewModel.candies.count)")
        }
    }
    private func checkCollisions() {
        let characterFrame = CGRect(x: characterViewModel.model.position,
                                    y: UIScreen.main.bounds.height - 100,
                                    width: 5, height: 25)

        candyViewModel.checkCollisionsAndRemove(characterFrame: characterFrame) { collidedCandy in
            SoundManager.shared.playSound("eat")
            startEatingAnimation()
        }
    }

    private func startEatingAnimation() {
        isEating = true
        characterViewModel.startEating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isEating = false
        }
    }

    private func loadGame() {
        if let savedGameState = gameState {
            let savedCandyState = savedGameState.candyState
            candyViewModel.loadState(savedCandyState)
            print("Game loaded. Score: \(candyViewModel.score), Candies: \(candyViewModel.candies.count)")
            resumeGameLoop()
            SoundManager.shared.playBackgroundMusic("bgm\(Int.random(in: 1...6))")
        } else {
            print("No saved game found. Starting new game.")
            startNewGame()
        }
    }
}


