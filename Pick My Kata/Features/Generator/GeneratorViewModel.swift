//
//  GeneratorViewModel.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class GeneratorViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentStyleName: String = "Loading..."
    @Published var generatedKata: String?
    @Published var errorMessage: String?

    // Stats for the new UI
    @Published var streakText: String = "..."
    @Published var totalKatasText: String = "..."
    @Published var longestStreakText: String = "..."
    // 'katasCompletedTodayText' has been removed.

    // MARK: - Private Properties
    
    private var userSettings: UserSettings?
    private var modelContext: ModelContext?

    // MARK: - Public Functions
    
    func loadData(context: ModelContext) {
        self.modelContext = context
        let settings = PersistenceService.fetchOrCreateSettings(context: context)
        self.userSettings = settings
        updatePublishedProperties()
    }
    
    func generateKata() {
        guard let settings = userSettings else {
            errorMessage = "Error: Settings not loaded."
            return
        }
        self.errorMessage = nil
        
        // (Kata generation logic is identical to before)
        guard let style = KarateStyle(rawValue: settings.selectedStyle) else {
            errorMessage = "Error: Invalid style selected."
            return
        }
        guard let masterList = KataProvider.masterList[style] else {
            errorMessage = "Error: No kata list found for this style."
            return
        }
        let excludedList = settings.exclusionList
            .first(where: { $0.styleName == style.rawValue })?
            .excludedKatas ?? []
        let activeList = masterList.filter { !excludedList.contains($0) }
        
        if activeList.isEmpty {
            errorMessage = "No katas selected. Please check Settings."
            self.generatedKata = nil
            return
        }
        
        var newKata = activeList.randomElement()
        if activeList.count > 1, let lastKata = self.generatedKata {
            while newKata == lastKata {
                newKata = activeList.randomElement()
            }
        }
        self.generatedKata = newKata
    }
    
    func completeKata() {
        guard let settings = userSettings,
              let completedKataName = generatedKata
        else {
            errorMessage = "Error: No kata to complete."
            return
        }
        
        // 1. Log Practice
        let newLog = PracticeLog(kataName: completedKataName, datePracticed: Date())
        settings.practiceLogs.append(newLog)
        
        // 2. Update Streak
        let today = Date()
        if !settings.lastPracticeDate.isToday {
            if settings.lastPracticeDate.isYesterday {
                settings.currentStreak += 1
            } else {
                settings.currentStreak = 1
            }
            settings.lastPracticeDate = today
            
            // 3. Update Longest Streak
            if settings.currentStreak > settings.longestStreak {
                settings.longestStreak = settings.currentStreak
            }
        }
        
        // 4. Update all UI properties
        updatePublishedProperties()
        
        // 5. Get next kata
        generateKata()
    }

    // MARK: - Private Helper Functions
    
    private func updatePublishedProperties() {
        guard let settings = userSettings else { return }
        
        if let style = KarateStyle(rawValue: settings.selectedStyle) {
            self.currentStyleName = style.displayName
        } else {
            self.currentStyleName = "Unknown Style"
        }
        
        // 1. Current Streak
        self.streakText = "🔥 \(settings.currentStreak) day streak"
        
        // 2. Total Katas
        let total = settings.practiceLogs.count
        self.totalKatasText = "\(total)"
        
        // 3. Best Streak
        let longest = settings.longestStreak
        self.longestStreakText = "\(longest)"
        
        // 'katasCompletedTodayText' logic removed.
        
        self.errorMessage = nil
    }
}
