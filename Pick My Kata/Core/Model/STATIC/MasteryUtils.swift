//
//  MasteryUtils.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftUI

struct MasteryTier: Equatable, Identifiable {
    var id: String { title }
    let title: String
    let icon: String
    let color: Color
    let lowerBound: Int
    let upperBound: Int
    let message: String
}

struct MasteryUtils {
    
    // 1. Define all tiers in a single ordered list
    static let allTiers: [MasteryTier] = [
        MasteryTier(
            title: "Foundations",
            icon: "book.fill",
            color: .green,
            lowerBound: 0,
            upperBound: 25,
            message: "Every journey begins with a single step."
        ),
        MasteryTier(
            title: "Student",
            icon: "hammer.fill",
            color: .orange,
            lowerBound: 25,
            upperBound: 50,
            message: "Consistency is the key. You are forging your technique."
        ),
        MasteryTier(
            title: "Competitor",
            icon: "figure.kickboxing",
            color: .red,
            lowerBound: 50,
            upperBound: 100,
            message: "Your spirit is strong! You are ready to test your limits."
        ),
        MasteryTier(
            title: "Dojo Leader",
            icon: "figure.flexibility",
            color: .blue,
            lowerBound: 100,
            upperBound: 200,
            message: "You set the example. Others now look to you for guidance."
        ),
        MasteryTier(
            title: "Kata Master",
            icon: "figure.martial.arts",
            color: .purple,
            lowerBound: 200,
            upperBound: Int.max,
            message: "True mastery is a journey without end."
        )
    ]
    
    // 2. Helper to find the current tier based on count
    static func getTier(for count: Int) -> MasteryTier {
        // Find the first tier where the count fits in the range
        return allTiers.first { count >= $0.lowerBound && count < $0.upperBound }
            ?? allTiers.last! // Fallback to Master if count is huge
    }
}
