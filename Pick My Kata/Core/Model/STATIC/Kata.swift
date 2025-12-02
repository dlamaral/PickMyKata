//
//  Kata.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 23/10/2025.
//

import Foundation

// 1. We define the difficulty levels
public enum KataDifficulty: String, Codable, Hashable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    case master = "Master"
}

// 2. We define the Kata struct itself
// It's Hashable and Identifiable so SwiftUI can use it in lists
public struct Kata: Hashable, Identifiable {
    // We use 'name' as the unique ID
    public var id: String { name }
    
    let name: String
    let description: String
    let difficulty: KataDifficulty
    
    // We can add more properties here later (e.g., videoUrl, history)
}
