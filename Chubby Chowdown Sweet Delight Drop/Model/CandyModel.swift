//
//  CandyModel.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 04.07.2024.
//

// CandyModel.swift

import Foundation

struct CandyModel: Identifiable {
    let id = UUID()
    var position: CGPoint
    let animationName: String
    let speed: CGFloat
    var isEaten: Bool = false
    
    init(screenWidth: CGFloat) {
        self.position = CGPoint(x: CGFloat.random(in: 25...screenWidth-25), y: -100)
        self.animationName = "candy_\(Int.random(in: 1...20))"
        self.speed = CGFloat.random(in: 50...60)
    }
}

