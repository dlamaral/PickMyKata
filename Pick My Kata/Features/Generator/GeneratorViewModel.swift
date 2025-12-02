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

// MARK: - GeneratorViewModel
@MainActor
class GeneratorViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentStyleName: String = "Loading..."
    @Published var generatedKata: Kata?
    @Published var errorMessage: String?
    
    // Stats for the UI
    @Published var streakText: String = "..."
    @Published var streakIcon: String = "🔥"
    @Published var streakColor: Color = .orange
    @Published var totalKatasText: String = "..."
    @Published var longestStreakText: String = "..."
    
    // "Today's Progress" properties
    @Published var progressText: String = "..."
    @Published var progressValue: Float = 0.0
    @Published var progressMotivationalText: String = "Keep going!"
    
    // Celebration States
    @Published var showCelebration: Bool = false
    @Published var showLevelUp: Bool = false
    @Published var newlyUnlockedTier: MasteryTier?
    
    // MARK: - Private Properties
    private var userSettings: UserSettings?
    private var modelContext: ModelContext?
    
    // MARK: - Public Functions
    
    func loadData(context: ModelContext) {
        self.modelContext = context
        let settings = PersistenceService.fetchOrCreateSettings(context: context)
        self.userSettings = settings
        
        // Update all UI properties with the loaded data
        updatePublishedProperties()
        
        // Refresh notifications on launch
        if settings.dailyReminderEnabled {
            let target = settings.dailyKataTarget
            let todayCount = settings.practiceLogs.filter{ $0.datePracticed.isToday }.count
            let isDone = todayCount >= target
            
            NotificationService.shared.scheduleUpcomingReminders(isGoalMetForToday: isDone)
        }
    }
    
    func generateKata() {
        AudioService.shared.playClickSound()
        self.showCelebration = false
        
        guard let settings = userSettings else {
            errorMessage = "Error: Settings not loaded."
            return
        }
        self.errorMessage = nil
        
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
        
        let activeList = masterList.filter { kata in
            !excludedList.contains(kata.name)
        }
        
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
    
    func getMasteryLevel(for kataName: String) -> MasteryTier? {
        guard let settings = userSettings else { return nil }
        let count = settings.practiceLogs.filter { $0.kataName == kataName }.count
        return MasteryUtils.getTier(for: count)
    }
    
    func completeKata() {
        guard let settings = userSettings,
              let completedKata = generatedKata
        else { return }
        
        // 1. Calculate Old Count & Tier (For Level Up check)
        let previousCount = settings.practiceLogs.filter { $0.kataName == completedKata.name }.count
        let previousTier = MasteryUtils.getTier(for: previousCount)
        
        // 2. Log the practice
        let newLog = PracticeLog(kataName: completedKata.name, datePracticed: Date())
        settings.practiceLogs.append(newLog)
        
        // 3. Update Streaks
        let today = Date()
        if !settings.lastPracticeDate.isToday {
            if settings.lastPracticeDate.isYesterday {
                settings.currentStreak += 1
            } else {
                settings.currentStreak = 1
            }
            settings.lastPracticeDate = today
            
            if settings.currentStreak > settings.longestStreak {
                settings.longestStreak = settings.currentStreak
            }
        }
        
        // 4. Calculate New Tier & Check Level Up
        let newCount = previousCount + 1
        let newTier = MasteryUtils.getTier(for: newCount)
        
        if previousTier.title != newTier.title {
            // Level Up!
            self.newlyUnlockedTier = newTier
            self.showLevelUp = true
            
            if settings.soundEffectsEnabled {
                AudioService.shared.playLevelUpSound()
            }
        } else {
            // Standard Completion
            if settings.soundEffectsEnabled {
                AudioService.shared.playCompletionSound()
            }
        }
        
        // 5. Notification Logic (Cancel if goal met)
        let target = settings.dailyKataTarget
        let todayCount = settings.practiceLogs.filter { $0.datePracticed.isToday }.count
        
        if settings.dailyReminderEnabled {
            if todayCount >= target {
                NotificationService.shared.cancelTodayReminder()
            } else {
                NotificationService.shared.scheduleUpcomingReminders(isGoalMetForToday: false)
            }
        }
        
        // 6. Update UI
        updatePublishedProperties()
        
        // 7. Decide Next Step
        if todayCount == target {
            // Target Hit Celebration
            self.showCelebration = true
            self.generatedKata = nil
        } else if !showLevelUp {
            // Only move to next kata if we aren't showing a level-up popup
            generateKata()
        }
    }
    
    func dismissLevelUp() {
        self.showLevelUp = false
        self.newlyUnlockedTier = nil
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
        
        // Streak Logic
        let calendar = Calendar.current
        let isStreakAlive = calendar.isDateInToday(settings.lastPracticeDate) || calendar.isDateInYesterday(settings.lastPracticeDate)
        
        if isStreakAlive {
            self.streakIcon = "🔥"
            self.streakColor = .orange
            self.streakText = "\(settings.currentStreak) day streak"
        } else {
            self.streakIcon = "🧊"
            self.streakColor = .blue
            self.streakText = "No streak"
        }
        
        self.totalKatasText = "\(settings.practiceLogs.count)"
        self.longestStreakText = "\(settings.longestStreak)"
        self.errorMessage = nil
        
        // Progress Logic
        let target = settings.dailyKataTarget
        let todayCount = settings.practiceLogs.filter { $0.datePracticed.isToday }.count
        
        self.progressText = "\(todayCount)/\(target)"
        
        if target > 0 {
            let rawProgress = Float(todayCount) / Float(target)
            self.progressValue = min(rawProgress, 1.0)
        } else {
            self.progressValue = 0.0
        }
        
        if todayCount > target {
            self.progressMotivationalText = "What an effort! 🤯"
        } else if todayCount >= target && target > 0 {
            self.progressMotivationalText = "Great job! 🎉"
        } else {
            self.progressMotivationalText = "Keep going!"
        }
    }
}
