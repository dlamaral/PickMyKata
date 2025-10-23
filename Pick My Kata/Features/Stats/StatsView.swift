//
//  StatsView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 22/10/2025.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    // 1. We own the ViewModel for this view.
    @StateObject private var viewModel = StatsViewModel()
    
    // 2. We query for the UserSettings object to pass to the ViewModel.
    @Query private var settingsQuery: [UserSettings]
    
    // 3. We get the 'dismiss' action from the environment
    //    so we can close this modal sheet.
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // 4. We use a NavigationStack to get a nav bar
        //    on our modal sheet for the title and Done button.
        NavigationStack {
            Form {
                
                // 5. Section 1: All-Time Stats
                Section(header: Text("All-Time Stats")) {
                    // These strings are fully formatted by the ViewModel
                    Text(viewModel.longestStreakText)
                    Text(viewModel.totalPracticedText)
                }
                
                // 6. Section 2: Practice Frequency
                Section(header: Text("Practice Frequency")) {
                    if viewModel.kataFrequency.isEmpty {
                        // Show a message if no katas have been completed
                        Text("No katas completed yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        // List all practiced katas, sorted by count
                        ForEach(viewModel.kataFrequency) { stat in
                            HStack {
                                Text(stat.kataName)
                                Spacer()
                                Text("\(stat.count)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Stats")
            .navigationBarTitleDisplayMode(.inline)
            // 7. Toolbar with "Done" button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss() // Close the sheet
                    }
                }
            }
            // 8. Load Data
            // When the view appears, find the settings object and
            // tell the ViewModel to calculate the stats.
            .onAppear {
                if let settings = settingsQuery.first {
                    viewModel.loadStats(from: settings)
                } else {
                    // This should be impossible if the app has run once.
                    print("FATAL ERROR: Could not find UserSettings in StatsView.")
                }
            }
        }
    }
}

#Preview {
    // 1. Set up a mock in-memory database
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, PracticeLog.self, configurations: config)
    
    // 2. Create sample settings
    let sampleSettings = UserSettings(currentStreak: 3, longestStreak: 5)
    
    // 3. Create sample practice logs
    let log1 = PracticeLog(kataName: "Heian Shodan", datePracticed: Date())
    let log2 = PracticeLog(kataName: "Heian Nidan", datePracticed: Date())
    let log3 = PracticeLog(kataName: "Heian Shodan", datePracticed: Date()) // A repeat
    
    // 4. Insert data into the mock context
    container.mainContext.insert(sampleSettings)
    // 5. Link the logs to the settings
    sampleSettings.practiceLogs.append(contentsOf: [log1, log2, log3])

    // 6. Render the view with the mock data
    return StatsView()
        .modelContainer(container)
}
