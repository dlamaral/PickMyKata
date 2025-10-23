//
//  MigrationPlan.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftData
import Foundation

// MARK: - SwiftData Migration Plan
// Maintains versioned schemas for UserSettings and PracticeLog.
// Uses lightweight migration from V1 (UserSettings only) to V2 (adds PracticeLog).

// 1. Define Version 1 (The Original Schema)
// We snapshot exactly what the model looked like before we added logs.
enum PickMyKataSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [UserSettings.self]
    }
    
    @Model
    final class UserSettings {
        var selectedStyle: String
        var currentStreak: Int
        var lastPracticeDate: Date
        var exclusionList: [StyleExclusion]

        public init(
            selectedStyle: String = "Shotokan",
            currentStreak: Int = 0,
            lastPracticeDate: Date = Date.distantPast,
            exclusionList: [StyleExclusion] = []
        ) {
            self.selectedStyle = selectedStyle
            self.currentStreak = currentStreak
            self.lastPracticeDate = lastPracticeDate
            self.exclusionList = exclusionList
        }
    }
}

// Current schema: adds PracticeLog to support detailed practice history.
enum PickMyKataSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        // Includes the new PracticeLog model
        [UserSettings.self, PracticeLog.self]
    }
}

// Migration plan: declares the schema versions and the lightweight stage from V1 → V2.
enum PickMyKataMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [PickMyKataSchemaV1.self, PickMyKataSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: PickMyKataSchemaV1.self,
        toVersion: PickMyKataSchemaV2.self
    )
}

