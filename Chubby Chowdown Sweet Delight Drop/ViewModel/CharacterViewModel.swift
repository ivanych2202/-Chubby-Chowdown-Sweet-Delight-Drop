//
//  CharacterViewModel.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//
// CharacterViewModel.swift
import Foundation
import Combine

class CharacterViewModel: ObservableObject {
    @Published var model: CharacterModel
    @Published var animationName: String = "roundel-idle"
    
    private let screenWidth: CGFloat

    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
        let initialPosition = screenWidth / 2
        self.model = CharacterModel(
            position: initialPosition,
            targetPosition: initialPosition,
            minX: 50,
            maxX: screenWidth - 50
        )
    }
    
    func resetPosition() {
        model.position = screenWidth / 2
        model.targetPosition = screenWidth / 2
        model.direction = .idle
        updateAnimationName()
    }
    
    func updateTargetPosition(_ newPosition: CGFloat) {
        model.targetPosition = min(max(newPosition, model.minX), model.maxX)
        updateDirection()
    }
    
    func updatePosition() {
        if abs(model.position - model.targetPosition) > model.speed {
            if model.position < model.targetPosition {
                model.position += model.speed
            } else if model.position > model.targetPosition {
                model.position -= model.speed
            }
            updateDirection()
        } else {
            model.position = model.targetPosition
            if !model.isDragging {
                model.direction = .idle
            }
        }
        updateAnimationName()
    }
    
    private func updateDirection() {
        if model.targetPosition > model.position + 1 {
            model.direction = .right
        } else if model.targetPosition < model.position - 1 {
            model.direction = .left
        } else {
            model.direction = .idle
        }
    }
    
    func stopMovement() {
        model.isDragging = false
        model.direction = .idle
        updateAnimationName()
    }
    
    func startEating() {
        animationName = "roundel-eat"
    }
    
    func stopEating() {
        updateAnimationName()
    }
    
    private func updateAnimationName() {
        switch model.direction {
        case .idle:
            animationName = "roundel-idle"
        case .left:
            animationName = "roundel-walk_left"
        case .right:
            animationName = "roundel-walk_right"
        }
    }
}
