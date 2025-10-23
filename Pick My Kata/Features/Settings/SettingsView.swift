//
//  SettingsView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    // 1. We own the ViewModel for this view.
    @StateObject private var viewModel = SettingsViewModel()
    
    // 2. We use @Query to find the UserSettings object that
    //    was created and saved by the GeneratorView.
    //    We know this will return an array, but we only
    //    ever expect one object in it.
    @Query private var settingsQuery: [UserSettings]
    
    var body: some View {
        // 3. A Form is the standard SwiftUI container for settings.
        Form {
            
            // 4. Section 1: The Style Selector
            Section(header: Text("Select Style")) {
                Picker("Style", selection: $viewModel.selectedStyle) {
                    ForEach(viewModel.allStyles, id: \.self) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // 5. Section 2: The Kata Exclusion List
            Section(header: Text("Manage Active Katas")) {
                // We list all katas for the selected style.
                ForEach(viewModel.kataList, id: \.self) { kata in
                    
                    // We make each row a button to toggle its status.
                    Button(action: {
                        viewModel.toggleExclusion(for: kata)
                    }) {
                        HStack {
                            Text(kata)
                                .foregroundStyle(.primary) // Keep text black
                            
                            Spacer()
                            
                            // 6. Show a checkmark ONLY if the kata
                            //    is NOT excluded.
                            if !viewModel.isKataExcluded(kata) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // 7. When the view appears, we find our settings object
            //    from the query and pass it to the ViewModel
            //    so it can load the correct data.
            if let settings = settingsQuery.first {
                viewModel.loadData(settings: settings)
            } else {
                // This is an error state, but should be impossible
                // if the GeneratorView has loaded at least once.
                print("FATAL ERROR: Could not find UserSettings in SettingsView.")
            }
        }
    }
}

#Preview {
    // We create a mock in-memory container for the preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, configurations: config)
    
    // Create and insert a sample settings object for the preview to use
    let sampleSettings = UserSettings(
        selectedStyle: KarateStyle.shotokan.rawValue,
        exclusionList: [
            StyleExclusion(styleName: "Shotokan", excludedKatas: ["Heian Nidan"])
        ]
    )
    container.mainContext.insert(sampleSettings)
    
    return NavigationStack {
        SettingsView()
    }
    .modelContainer(container) // Inject the container into the preview
}
