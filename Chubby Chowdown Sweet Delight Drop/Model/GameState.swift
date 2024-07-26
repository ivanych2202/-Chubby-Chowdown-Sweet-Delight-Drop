//
//  GameState.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 26.07.2024.
//

struct GameState: Codable {
    let candyState: CandyState
}

struct CandyState: Codable {
    let candies: [CandyModel]
    let score: Int
    let isGameOver: Bool
}
