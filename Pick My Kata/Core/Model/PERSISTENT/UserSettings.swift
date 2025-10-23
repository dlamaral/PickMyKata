//
//  UserSettings.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation
import SwiftData

@Model
public final class UserSettings {
    
    // MARK: - Existing Properties
    var selectedStyle: String
    var currentStreak: Int
    var lastPracticeDate: Date
    var exclusionList: [StyleExclusion]
    var longestStreak: Int
    @Relationship(deleteRule: .cascade)
    var practiceLogs: [PracticeLog] = []

    // MARK: - NEW PROPERTIES
    
    /// The user's daily practice goal (1-10 katas).
    var dailyKataTarget: Int
    
    /// True if the user wants a daily practice reminder.
    var dailyReminderEnabled: Bool
    
    /// True if the user wants sound effects.
    var soundEffectsEnabled: Bool

    // MARK: - UPDATED Initializer
    
    public init(
        // Existing defaults
        selectedStyle: String = KarateStyle.shotokan.rawValue,
        currentStreak: Int = 0,
        lastPracticeDate: Date = Date.distantPast,
        exclusionList: [StyleExclusion] = [],
        longestStreak: Int = 0,
        
        // --- Add new properties to init ---
        
        /// Default goal is 3 katas per day.
        dailyKataTarget: Int = 3,
        
        /// Default is reminders off.
        dailyReminderEnabled: Bool = false,
        
        /// Default is sound effects off.
        soundEffectsEnabled: Bool = false
    ) {
        self.selectedStyle = selectedStyle
        self.currentStreak = currentStreak
        self.lastPracticeDate = lastPracticeDate
        self.exclusionList = exclusionList
        self.longestStreak = longestStreak
        
        // Set new properties
        self.dailyKataTarget = dailyKataTarget
        self.dailyReminderEnabled = dailyReminderEnabled
        self.soundEffectsEnabled = soundEffectsEnabled
    }
}
