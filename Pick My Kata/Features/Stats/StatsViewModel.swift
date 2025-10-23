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

// 1. We define a simple struct to hold our frequency data.
//    Conforming to 'Identifiable' makes it trivial to
//    use in a SwiftUI 'List' or 'ForEach'.
public struct KataStat: Identifiable {
    public let id = UUID()
    let kataName: String
    let count: Int
}

@MainActor
class StatsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // 2. These are the outputs the View will display.
    
    /// Formatted text for the "Longest Streak" stat.
    @Published var longestStreakText: String = "Loading..."
    
    /// Formatted text for the "Total Katas Practiced" stat.
    @Published var totalPracticedText: String = "Loading..."
    
    /// A sorted array of practice frequency for the list.
    @Published var kataFrequency: [KataStat] = []
    
    // MARK: - Public Function
    
    /// Loads and processes all stats from the UserSettings.
    /// - Parameter settings: The 'UserSettings' object from the SwiftData query.
    func loadStats(from settings: UserSettings) {
        
        // 3. --- Longest Streak ---
        let longest = settings.longestStreak
        // Add "s" for plural, e.g., "1 Day" vs "5 Days"
        self.longestStreakText = "🏆 \(longest) Day\(longest == 1 ? "" : "s")"
        
        // 4. --- Total Katas Practiced ---
        let total = settings.practiceLogs.count
        self.totalPracticedText = "🥋 \(total) Kata\(total == 1 ? "" : "s")"
        
        // 5. --- Kata Frequency ---
        
        // A. Use a dictionary to count all occurrences.
        var counts: [String: Int] = [:]
        for log in settings.practiceLogs {
            counts[log.kataName, default: 0] += 1
        }
        
        // B. Convert the dictionary into our 'KataStat' array.
        let statsArray = counts.map { (kataName, count) in
            KataStat(kataName: kataName, count: count)
        }
        
        // C. Sort the array from most-practiced to least-practiced.
        self.kataFrequency = statsArray.sorted { $0.count > $1.count }
    }
}
