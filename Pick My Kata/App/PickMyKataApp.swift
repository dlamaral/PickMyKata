//
//  PickMyKataApp.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import SwiftUI
import SwiftData

@main
struct PickMyKataApp: App {

    // 1. This creates the shared SwiftData database container.
    // It's configured to manage our 'UserSettings' and 'PracticeLog' model.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserSettings.self,
            PracticeLog.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // 2. This is the main body of the app.
    var body: some Scene {
        WindowGroup {
            // 3. We use a NavigationStack to allow navigation from the
            // GeneratorView (root) to the SettingsView.
            NavigationStack {
                GeneratorView()
            }
        }
        // 4. This injects the database into the entire app's environment.
        // Any view inside this WindowGroup can now access our data.
        .modelContainer(sharedModelContainer)
    }
}
