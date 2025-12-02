//
//  SettingsViewModel.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // 1. Daily Reminder Toggle
    @Published var dailyReminderEnabled: Bool = false {
        didSet {
            // Only update DB if changed to avoid redundant writes
            if userSettings?.dailyReminderEnabled != dailyReminderEnabled {
                userSettings?.dailyReminderEnabled = dailyReminderEnabled
                handleReminderToggle(isOn: dailyReminderEnabled)
            }
        }
    }
    
    // 2. Daily Target Slider
    @Published var dailyKataTarget: Double = 3.0 {
        didSet {
            userSettings?.dailyKataTarget = Int(dailyKataTarget)
        }
    }
    
    // 3. Sound Effects Toggle
    @Published var soundEffectsEnabled: Bool = false {
        didSet {
            userSettings?.soundEffectsEnabled = soundEffectsEnabled
        }
    }
    
    // 4. Style Selection
    @Published var selectedStyle: KarateStyle = .shotokan {
        didSet {
            userSettings?.selectedStyle = selectedStyle.rawValue
            loadKataList()
        }
    }
    
    // 5. Data Lists
    @Published var allStyles: [KarateStyle] = KarateStyle.allCases
    @Published var kataList: [Kata] = []
    
    // MARK: - Private Properties
    private var userSettings: UserSettings?
    private var modelContext: ModelContext?

    // MARK: - Initialization & Loading
    
    func loadData(context: ModelContext) {
        self.modelContext = context
        let settings = PersistenceService.fetchOrCreateSettings(context: context)
        self.userSettings = settings
        
        // Load values from Database into UI
        self.selectedStyle = KarateStyle(rawValue: settings.selectedStyle) ?? .shotokan
        self.dailyReminderEnabled = settings.dailyReminderEnabled
        self.dailyKataTarget = Double(settings.dailyKataTarget)
        self.soundEffectsEnabled = settings.soundEffectsEnabled
        
        loadKataList()
    }
    
    // MARK: - Reminder Logic (Fixed)
    
    private func handleReminderToggle(isOn: Bool) {
        if isOn {
            // Use the Shared Singleton
            NotificationService.shared.requestPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        // Schedule the 7-day queue
                        NotificationService.shared.scheduleUpcomingReminders(isGoalMetForToday: false)
                    } else {
                        // Permission denied, revert UI
                        self?.dailyReminderEnabled = false
                    }
                }
            }
        } else {
            // Cancel everything
            NotificationService.shared.cancelAllReminders()
        }
    }
    
    // MARK: - Exclusion Logic (Cleaned Up)
    
    private func loadKataList() {
        self.kataList = KataProvider.masterList[selectedStyle] ?? []
    }
    
    func isKataExcluded(_ name: String) -> Bool {
        guard let settings = userSettings else { return false }
        
        // Find the exclusion entry for the current style
        if let entry = settings.exclusionList.first(where: { $0.styleName == selectedStyle.rawValue }) {
            return entry.excludedKatas.contains(name)
        }
        return false
    }
    
    func toggleExclusion(for kataName: String) {
        guard let settings = userSettings else { return }
        
        // Get or Create the exclusion entry
        var entry: StyleExclusion
        if let existing = settings.exclusionList.first(where: { $0.styleName == selectedStyle.rawValue }) {
            entry = existing
        } else {
            entry = StyleExclusion(styleName: selectedStyle.rawValue, excludedKatas: [])
            settings.exclusionList.append(entry)
        }
        
        // Toggle Logic
        if entry.excludedKatas.contains(kataName) {
            entry.excludedKatas.removeAll { $0 == kataName }
        } else {
            entry.excludedKatas.append(kataName)
        }
        
        // Force UI Refresh
        self.objectWillChange.send()
    }
    
    // MARK: - Danger Zone
    
    func resetProgress() {
        guard let settings = userSettings else { return }
        
        // 1. Wipe Logs
        settings.practiceLogs.removeAll()
        
        // 2. Reset Streaks
        settings.currentStreak = 0
        settings.longestStreak = 0
        settings.lastPracticeDate = Date.distantPast
        
        // 3. Force UI Refresh
        objectWillChange.send()
    }
}
