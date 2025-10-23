//
//  StatsView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 22/10/2025.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    @StateObject private var viewModel = StatsViewModel()
    @Query private var settingsQuery: [UserSettings]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 1. Header (Total Stats)
                        HStack(spacing: 12) {
                            StatCardView(value: viewModel.totalPracticedText, label: "Total Katas")
                            StatCardView(value: viewModel.longestStreakText, label: "Best Streak")
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // 2. Title
                        HStack {
                            Text("Kata Mastery")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(viewModel.allMasteryData.count) Total")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal)
                        
                        // 3. The List
                        LazyVStack(spacing: 12) {
                            
                            // Determine how many items to show
                            let itemsToShow = viewModel.showAllKatas ? viewModel.allMasteryData : Array(viewModel.allMasteryData.prefix(5))
                            
                            ForEach(itemsToShow) { data in
                                MasteryRowView(data: data)
                            }
                            
                            // 4. The "View All" Button
                            if !viewModel.showAllKatas && viewModel.allMasteryData.count > 5 {
                                Button(action: {
                                    withAnimation {
                                        viewModel.showAllKatas = true
                                    }
                                }) {
                                    Text("View All \(viewModel.allMasteryData.count) Katas")
                                        .font(.headline)
                                        .foregroundStyle(.red)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red, lineWidth: 1.5)
                                        )
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("My Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                if let settings = settingsQuery.first {
                    viewModel.loadStats(from: settings)
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
