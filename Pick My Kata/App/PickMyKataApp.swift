//
//  PickMyKataApp.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import SwiftUI
import SwiftData

// MARK: - App Entry
// Configures SwiftData with a versioned schema and migration plan.
// Decides between Onboarding and the main Generator flow using @AppStorage.
@main
struct PickMyKataApp: App {
    
    // 1. Check if the user has finished onboarding
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    let container: ModelContainer
    
    init() {
        do {
            // Build the latest schema and pass it to the model container (with migration plan).
            // 1. Create a Schema object from our V2 definition
            let schema = Schema(versionedSchema: PickMyKataSchemaV2.self)
            
            // 2. Pass that 'schema' object to the container
            container = try ModelContainer(
                for: schema,
                migrationPlan: PickMyKataMigrationPlan.self
            )
            // -------------------
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        // Root scene: routes to Onboarding until the user completes it, then to Generator.
        WindowGroup {
            // 2. Switch logic
            if hasCompletedOnboarding {
                NavigationStack {
                    GeneratorView()
                }
            } else {
                // No NavigationStack here, Onboarding handles its own flow
                OnboardingView()
            }
        }
        .modelContainer(container)
    }
}

