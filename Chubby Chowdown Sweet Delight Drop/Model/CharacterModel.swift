//
//  CharacterModel.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

import Foundation

struct CharacterModel {
    var position: CGFloat
    var targetPosition: CGFloat
    var direction: Direction = .idle
    var isDragging: Bool = false
    let minX: CGFloat
    let maxX: CGFloat
    let speed: CGFloat = 3

    init(position: CGFloat, targetPosition: CGFloat, minX: CGFloat, maxX: CGFloat) {
        self.position = position
        self.targetPosition = targetPosition
        self.minX = minX
        self.maxX = maxX
    }
}

enum Direction {
    case idle, left, right
}
