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
    
    // MARK: - NEW PROPERTIES
    
    /// The user's all-time longest practice streak.
    var longestStreak: Int
    
    /// A one-to-many relationship linking this settings object
    /// to all of the user's individual practice logs.
    /// '.cascade' means deleting the UserSettings will delete all its logs.
    @Relationship(deleteRule: .cascade)
    var practiceLogs: [PracticeLog] = []

    // MARK: - UPDATED Initializer
    
    public init(
        // Existing defaults
        selectedStyle: String = KarateStyle.shotokan.rawValue,
        currentStreak: Int = 0,
        lastPracticeDate: Date = Date.distantPast,
        exclusionList: [StyleExclusion] = [],
        
        // --- Add new property to init ---
        
        /// The default longest streak for a new user is 0.
        longestStreak: Int = 0
    ) {
        self.selectedStyle = selectedStyle
        self.currentStreak = currentStreak
        self.lastPracticeDate = lastPracticeDate
        self.exclusionList = exclusionList
        self.longestStreak = longestStreak
        // 'practiceLogs' is already initialized to [] by default.
    }
}
