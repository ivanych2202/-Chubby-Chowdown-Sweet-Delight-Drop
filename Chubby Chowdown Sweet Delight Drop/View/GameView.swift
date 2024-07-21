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
    @State private var isShowingGameOver: Bool = false
    @State private var isShowingPause: Bool = false
    @State private var gameLoopTimer: Timer?
    
    init(isShowingMenu: Binding<Bool>) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        _characterViewModel = StateObject(wrappedValue: CharacterViewModel(screenWidth: screenWidth))
        _candyViewModel = StateObject(wrappedValue: CandyViewModel(screenWidth: screenWidth, screenHeight: screenHeight))
        _isShowingMenu = isShowingMenu
    }
    
    var body: some View {
        ZStack {
            
            
            LottieView(animation: .named("background"))
                .playing(loopMode: .loop)
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            
            LottieView(animation: .named(characterViewModel.animationName))
                .playing(loopMode: .loop)
                .frame(width: 100, height: 100)
                .position(
                    x: characterViewModel.model.position,
                    y: UIScreen.main.bounds.height - 120
                )
            
            
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
                    if !characterViewModel.isEating && !candyViewModel.isGameOver && !isShowingPause {
                        characterViewModel.model.isDragging = true
                        characterViewModel.updateTargetPosition(value.location.x)
                    }
                }
                .onEnded { _ in
                    characterViewModel.model.isDragging = false
                }
        )
        .onAppear {
            startGameLoop()
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
                            isShowingMenu = true
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
                            isShowingMenu = true
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: isShowingPause)
                }
            }
        )
        
    }
    
    private func startGameLoop() {
        gameLoopTimer?.invalidate()
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if self.candyViewModel.isGameOver {
                self.gameLoopTimer?.invalidate()
                DispatchQueue.main.async {
                    self.isShowingGameOver = true
                }
                return
            }
            
            if !self.characterViewModel.isEating && !self.isShowingPause {
                self.characterViewModel.updatePosition()
                self.checkCollisions()
            }
        }
        candyViewModel.startGame()
    }
    
    
    private func pauseGame() {
        SoundManager.shared.pauseBackgroundMusic()
        isShowingPause = true
        candyViewModel.pauseGame()
    }
    
    private func resumeGame() {
        SoundManager.shared.resumeBackgroundMusic()
        isShowingPause = false
        candyViewModel.resumeGame()
    }
    
    private func restartGame() {
        SoundManager.shared.playBackgroundMusic("bgm\(Int.random(in: 1...6))")
        isShowingGameOver = false
        candyViewModel.resetGame()
        characterViewModel.resetPosition()
        startGameLoop()
    }
    
    private func checkCollisions() {
        let characterFrame = CGRect(x: characterViewModel.model.position,
                                    y: UIScreen.main.bounds.height - 100,
                                    width: 5, height: 25)
        
        for candy in candyViewModel.candies {
            let candyFrame = CGRect(x: candy.position.x - 25,
                                    y: candy.position.y - 25,
                                    width: 50, height: 50)
            
            if characterFrame.intersects(candyFrame) {
                SoundManager.shared.playSound("eat")
                characterViewModel.startEating()
                candyViewModel.removeCandy(candy)
                candyViewModel.score += 1
            }
            
        }
    }
}
