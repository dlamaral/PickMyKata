//
//  MasteryUtils.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftUI

struct MasteryTier: Equatable {
    let title: String
    let icon: String
    let color: Color
    let lowerBound: Int
    let upperBound: Int
    let message: String
}

struct MasteryUtils {
    
    static func getTier(for count: Int) -> MasteryTier {
        switch count {
        case 0..<25:
            return MasteryTier(
                title: "Foundations",
                icon: "book.fill",
                color: .green,
                lowerBound: 0,
                upperBound: 25,
                message: "Every journey begins with a single step. You are building the base."
            )
        case 25..<50:
            return MasteryTier(
                title: "Student",
                icon: "hammer.fill",
                color: .orange,
                lowerBound: 25,
                upperBound: 50,
                message: "Consistency is the key. You are forging your technique."
            )
        case 50..<100:
            return MasteryTier(
                title: "Competitor",
                icon: "figure.kickboxing",
                color: .red,
                lowerBound: 50,
                upperBound: 100,
                message: "Your spirit is strong! You are ready to test your limits."
            )
        case 100..<200:
            return MasteryTier(
                title: "Dojo Leader",
                icon: "figure.flexibility",
                color: .blue,
                lowerBound: 100,
                upperBound: 200,
                message: "You set the example. Others now look to you for guidance."
            )
        default:
            return MasteryTier(
                title: "Kata Master",
                icon: "figure.martial.arts",
                color: .purple,
                lowerBound: 200,
                upperBound: Int.max,
                message: "True mastery is a journey without end. Keep pushing boundaries."
            )
        }
    }
}
