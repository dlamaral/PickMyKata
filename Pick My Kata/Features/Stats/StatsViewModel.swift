//
//  StatsViewModel.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 22/10/2025.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

// Note: 'MasteryTier' is now defined in Core/Model/STATIC/MasteryUtils.swift
// We do NOT define it here to avoid "Invalid Redeclaration" errors.

struct KataMasteryData: Identifiable {
    let id = UUID()
    let kataName: String
    let styleName: String
    let count: Int
    let tier: MasteryTier
    let progressToNextLevel: Float
}

@MainActor
class StatsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var longestStreakText: String = "..."
    @Published var totalPracticedText: String = "..."
    
    @Published var allMasteryData: [KataMasteryData] = []
    @Published var showAllKatas: Bool = false
    
    // MARK: - Public Function
    func loadStats(from settings: UserSettings) {
        
        // 1. Calculate General Stats
        let longest = settings.longestStreak
        self.longestStreakText = "🏆 \(longest)"
        
        let total = settings.practiceLogs.count
        self.totalPracticedText = "🥋 \(total)"
        
        // 2. Get the list of katas for the selected style
        guard let style = KarateStyle(rawValue: settings.selectedStyle),
              let masterList = KataProvider.masterList[style] else {
            return
        }
        
        // 3. Count practices per kata
        var counts: [String: Int] = [:]
        for log in settings.practiceLogs {
            counts[log.kataName, default: 0] += 1
        }
        
        // 4. Build the rich data objects
        let calculatedData = masterList.map { kata in
            let count = counts[kata.name] ?? 0
            
            // --- CHANGE: USE SHARED UTILITY ---
            // We call the static function from our new file
            let tier = MasteryUtils.getTier(for: count)
            // ----------------------------------
            
            let progress = calculateProgress(count: count, tier: tier)
            
            return KataMasteryData(
                kataName: kata.name,
                styleName: style.displayName,
                count: count,
                tier: tier,
                progressToNextLevel: progress
            )
        }
        
        // 5. Sort by Count (Highest first)
        self.allMasteryData = calculatedData.sorted { $0.count > $1.count }
    }
    
    // MARK: - Helper Logic
    
    private func calculateProgress(count: Int, tier: MasteryTier) -> Float {
        // If max level, progress is 100%
        if tier.upperBound == Int.max { return 1.0 }
        
        // Calculate percentage within the current tier range
        // (e.g. If tier is 25-50, and count is 30. Range is 25. Progress is 5. Result is 5/25 = 0.2)
        let range = Float(tier.upperBound - tier.lowerBound)
        let progressInTier = Float(count - tier.lowerBound)
        
        // Clamp between 0.0 and 1.0
        return min(max(progressInTier / range, 0.0), 1.0)
    }
}
