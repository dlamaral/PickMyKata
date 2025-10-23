//
//  GeneratorView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import SwiftUI
import SwiftData

struct GeneratorView: View {
    
    @StateObject private var viewModel = GeneratorViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingStats = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // --- 1. Top Bar (Streak & Settings) ---
                    HStack {
                        Button(action: { isShowingStats = true }) {
                            HStack(spacing: 4) {
                                Text(viewModel.streakText)
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.orange.opacity(0.2))
                            .foregroundStyle(.orange.darker())
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    // --- 2. Title ---
                    VStack(spacing: 4) {
                        Text("Ready to Practice?")
                            .foregroundStyle(.secondary)
                        Text("Master your techniques, one kata at a time")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                    }

                    // --- 3. Main Kata Card ---
                    VStack(spacing: 20) {
                        Image(systemName: "figure.martial.arts")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding(20)
                            .background(Color.red)
                            .clipShape(Circle())
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.title2)
                                .foregroundStyle(.red)
                        } else if let kata = viewModel.generatedKata {
                            Text(kata)
                                .font(.title2)
                        } else {
                            Text("Tap 'Pick My Kata' to start")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("\(viewModel.currentStyleName) Karate")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(Capsule())

                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    
                    // --- 4. Action Buttons ---
                    VStack(spacing: 12) {
                        if viewModel.generatedKata == nil {
                            HStack(spacing: 12) {
                                primaryButton(title: "Pick My Kata", icon: "play.fill", color: .red) {
                                    viewModel.generateKata()
                                }
                            }
                        } else {
                            HStack(spacing: 12) {
                                primaryButton(title: "Mark as Done", icon: "checkmark", color: .green) {
                                    viewModel.completeKata()
                                }
                                
                                secondaryButton(title: "Skip", icon: "forward.fill") {
                                    viewModel.generateKata()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // --- 5. "Today's Progress" SECTION REMOVED ---
                    
                    // --- 6. Stats Grid ---
                    HStack(spacing: 12) {
                        StatCardView(value: viewModel.totalKatasText, label: "Total Katas")
                        // Updated to match the grid in the design
                        StatCardView(value: viewModel.streakText.components(separatedBy: " ").first ?? "0", label: "Current Streak")
                        StatCardView(value: viewModel.longestStreakText, label: "Best Streak")
                    }
                    .padding(.horizontal)

                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadData(context: modelContext)
        }
        .sheet(isPresented: $isShowingStats) {
            StatsView()
        }
    }
    
    // --- Helper functions for button styling ---
    
    func primaryButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundStyle(.white)
            .cornerRadius(12)
        }
    }
    
    func secondaryButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(uiColor: .systemGray4))
            .foregroundStyle(Color(uiColor: .label))
            .cornerRadius(12)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, PracticeLog.self, configurations: config)
    
    let sampleSettings = UserSettings(currentStreak: 7, longestStreak: 12)
    sampleSettings.practiceLogs = [
        PracticeLog(kataName: "Heian Shodan", datePracticed: Date()),
        PracticeLog(kataName: "Heian Nidan", datePracticed: Date()),
        PracticeLog(kataName: "Heian Shodan", datePracticed: Date())
    ]
    container.mainContext.insert(sampleSettings)
    
    return NavigationStack {
        GeneratorView()
    }
    .modelContainer(container)
}

// Helper extension for darker/lighter colors
extension Color {
    func darker(by percentage: Double = 30.0) -> Color {
        return self.adjust(by: -abs(percentage))
    }
    
    func adjust(by percentage: Double) -> Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Color(UIColor(
                red: min(max(0, red + percentage/100), 1.0),
                green: min(max(0, green + percentage/100), 1.0),
                blue: min(max(0, blue + percentage/100), 1.0),
                alpha: alpha
            ))
        } else {
            return self
        }
    }
}
