//
//  PersistenceService.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation
import SwiftData

// 1. We define a 'PersistenceService' struct to act as a
//    namespace for our persistence logic. It has no
//    properties and is never initialized.
public struct PersistenceService {

    // 2. This is the single, most important function in this file.
    //    It attempts to find the UserSettings. If it can't
    //    (e.g., a new user), it creates the default settings,
    //    inserts them into the database, and returns them.
    //
    //    This guarantees that the app *always* has a valid
    //    settings object to work with.
    //
    //    - Parameter context: The ModelContext from the SwiftUI environment.
    //    - Returns: The one-and-only UserSettings object.
    @MainActor // 3. We mark this as @MainActor to ensure database
               //    operations happen on the main thread, as required.
    static func fetchOrCreateSettings(context: ModelContext) -> UserSettings {
        
        // 4. Create a "fetch request" for the UserSettings.
        let descriptor = FetchDescriptor<UserSettings>()
        
        do {
            // 5. Try to fetch the settings from the database.
            let settingsArray = try context.fetch(descriptor)
            
            // 6. Check if we found one.
            if let settings = settingsArray.first {
                // SUCCESS: Returning user. Return the found settings.
                return settings
            } else {
                // FAILURE: New user. No settings were found.
                // Create a new settings object (using the defaults
                // we defined in its 'init').
                let newSettings = UserSettings()
                
                // Insert the new object into the database.
                context.insert(newSettings)
                
                // Note: We don't need to explicitly call 'context.save()'.
                // SwiftData's "implicit save" will handle this,
                // but we could add it here if we wanted to be explicit.
                
                return newSettings
            }
        } catch {
            // This is a fatal error. If we can't even fetch or
            // create settings, the app is in an unrecoverable state.
            fatalError("Failed to fetch or create UserSettings: \(error)")
        }
    }
}
