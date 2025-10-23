//
//  SettingsView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // We use StateObject so the ViewModel lives as long as the View
    @StateObject private var viewModel = SettingsViewModel()
    
    // -- STATE FOR ALERT ---
    @State private var showResetAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                // --- Section 1: Preferences ---
                Section(header: Text("Daily Goals")) {
                    // 1. Daily Target Slider
                    VStack(alignment: .leading) {
                        Text("Daily Target: \(Int(viewModel.dailyKataTarget)) Kata")
                        Slider(value: $viewModel.dailyKataTarget, in: 1...5, step: 1)
                    }
                    .padding(.vertical, 4)
                    
                    // 2. Daily Reminder Toggle
                    Toggle(isOn: $viewModel.dailyReminderEnabled) {
                        Label("Daily Reminder", systemImage: "bell.fill")
                    }
                    
                    // 3. Sound Effects Toggle
                    Toggle(isOn: $viewModel.soundEffectsEnabled) {
                        Label("Sound Effects", systemImage: "speaker.wave.2.fill")
                    }
                }
                
                // --- Section 2: Karate Style ---
                Section(header: Text("Karate Style")) {
                    Picker("Selected Style", selection: $viewModel.selectedStyle) {
                        ForEach(viewModel.allStyles, id: \.self) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                // --- Section 3: Kata Selection (Exclusions) ---
                Section(header: Text("Select Katas to Practice")) {
                    if viewModel.kataList.isEmpty {
                        Text("No katas available for this style.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.kataList) { kata in
                            // Create a binding to the exclusion status
                            let isIncluded = Binding<Bool>(
                                get: { !viewModel.isKataExcluded(kata.name) },
                                set: { _ in viewModel.toggleExclusion(for: kata.name) }
                            )
                            
                            Toggle(isOn: isIncluded) {
                                Text(kata.name)
                            }
                        }
                    }
                }
                .tint(.red) // Toggles turn Red when ON
                
                // --- Section 4: About ---
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    Link(destination: URL(string: "mailto:dlamaral12@gmail.com?subject=Pick My Kata Feedback/Feature Request")!) {
                        HStack {
                            Text("Contact Developer")
                                .foregroundStyle(.primary) // Keep text standard color
                            Spacer()
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                // --- Section 5: Danger Zone ---
                Section {
                    Button {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Text("Reset Progress")
                            Spacer()
                            Image(systemName: "trash")
                        }
                        .foregroundStyle(.red)
                    }
                } footer: {
                    Text("This will delete all practice logs and streaks.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.loadData(context: modelContext)
            }
            // -- DANGER ZONE ALERT LOGIC ---
            .alert("Are you sure?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset Everything", role: .destructive) {
                    viewModel.resetProgress()
                    // Haptic feedback for the delete action
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                }
            } message: {
                Text("This action will delete all of your progres and cannot be reversed. Are you sure you want to proceed?")
            }
        }
    }
}

#Preview {
    // Helper to preview with in-memory container
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, PracticeLog.self, configurations: config)
    
    return SettingsView()
        .modelContainer(container)
}
