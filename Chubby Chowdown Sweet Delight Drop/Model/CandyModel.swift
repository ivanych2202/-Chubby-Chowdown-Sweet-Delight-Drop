//
//  CandyModel.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

// CandyModel.swift

import Foundation
import CoreGraphics

struct CandyModel: Identifiable, Codable {
    let id: UUID
    var position: CGPoint
    let animationName: String
    let speed: CGFloat
    var isEaten: Bool

    init(screenWidth: CGFloat) {
        self.id = UUID()
        self.position = CGPoint(x: CGFloat.random(in: 25...screenWidth - 25), y: -100)
        self.animationName = "candy_\(Int.random(in: 1...20))"
        self.speed = CGFloat.random(in: 50...60)
        self.isEaten = false
    }

    // Добавим init для создания CandyModel при загрузке из сохраненного состояния
    init(id: UUID, position: CGPoint, animationName: String, speed: CGFloat, isEaten: Bool) {
        self.id = id
        self.position = position
        self.animationName = animationName
        self.speed = speed
        self.isEaten = isEaten
    }
}

// Encode/Decode CGPoint for CandyModel
extension CandyModel {
    private enum CodingKeys: String, CodingKey {
        case id, positionX, positionY, animationName, speed, isEaten
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(position.x, forKey: .positionX)
        try container.encode(position.y, forKey: .positionY)
        try container.encode(animationName, forKey: .animationName)
        try container.encode(speed, forKey: .speed)
        try container.encode(isEaten, forKey: .isEaten)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let x = try container.decode(CGFloat.self, forKey: .positionX)
        let y = try container.decode(CGFloat.self, forKey: .positionY)
        position = CGPoint(x: x, y: y)
        animationName = try container.decode(String.self, forKey: .animationName)
        speed = try container.decode(CGFloat.self, forKey: .speed)
        isEaten = try container.decode(Bool.self, forKey: .isEaten)
    }
}
