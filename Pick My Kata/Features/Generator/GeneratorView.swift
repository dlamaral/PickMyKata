//
//  GeneratorView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import SwiftUI
import SwiftData

// MARK: - GeneratorView
// Main practice screen: shows kata suggestions, progress, streaks, and actions.
// Handles celebration state and presents Settings and Stats.
struct GeneratorView: View {
    
    @StateObject private var viewModel = GeneratorViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingStats = false
    @State private var celebrationScale: CGFloat = 0.6
    
    private let descriptionFont = Font.subheadline
    
    // --- MAGIC NUMBER CONFIGURATION ---
    private let cardHeight: CGFloat = 200
    // ----------------------------------
    
    var body: some View {
        ZStack {
            // GLOBAL BACKGROUND
            Color(uiColor: .systemGroupedBackground).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // --- 1. Top Bar ---
                    HStack {
                        Button(action: { isShowingStats = true }) {
                            HStack(spacing: 4) {
                                Text(viewModel.streakIcon)
                                Text(viewModel.streakText)
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.streakColor.opacity(0.2))
                            .foregroundStyle(viewModel.streakColor.darker())
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(.orange.darker())
                                .padding(8)
                                .background(Color.orange.opacity(0.2))
                                .clipShape(Capsule())
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
                    // High-level: Switches between celebration state and the standard kata/error/start card.
                    VStack {
                        
                        // --- STATE A: DAILY GOAL CELEBRATION ---
                        if viewModel.showCelebration {
                            VStack(spacing: 20) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 80))
                                    .foregroundStyle(.yellow)
                                    .shadow(color: .orange, radius: 10)
                                    .scaleEffect(celebrationScale)
                                    .onAppear {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                                            celebrationScale = 1.0
                                        }
                                    }
                                
                                Text("Daily Target Hit!")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                Text("You are consistent and disciplined.\nGreat work today.")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            // This VStack naturally fills the taller frame defined below
                            
                        } else {
                            // --- STATE B: STANDARD (Start / Kata / Error) ---
                            VStack(spacing: 0) {
                                
                                Image(systemName: "figure.martial.arts")
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                                    .padding(20)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .padding(.bottom, 20)

                                if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .font(.title2)
                                        .foregroundStyle(.red)
                                        .multilineTextAlignment(.center)
                                        // Use fixed cardHeight for alignment
                                        .frame(height: cardHeight, alignment: .center)
                                    
                                } else if let kata = viewModel.generatedKata {
                                    VStack(spacing: 12) {
                                        
                                        // --- MASTERY BADGE ---
                                        if let mastery = viewModel.getMasteryLevel(for: kata.name) {
                                            HStack(spacing: 4) {
                                                Image(systemName: mastery.icon)
                                                Text(mastery.title)
                                            }
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(mastery.color.opacity(0.2))
                                            .foregroundStyle(mastery.color)
                                            .clipShape(Capsule())
                                            .padding(.bottom, 4)
                                        }
                                        // ---------------------
                                        
                                        Text(kata.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(3)
                                            .minimumScaleFactor(0.9)

                                        Text(kata.description)
                                            .font(descriptionFont)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                            .lineLimit(6)
                                            .minimumScaleFactor(0.85)

                                        HStack(spacing: 5) {
                                            Text("Difficulty:")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            Text(kata.difficulty.rawValue)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                    // Use fixed cardHeight for alignment
                                    .frame(height: cardHeight, alignment: .center)
                                    
                                } else {
                                    // Start State
                                    Text("Tap 'Pick My Kata' to start")
                                        .font(.title2)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        // Use fixed cardHeight for alignment
                                        .frame(height: cardHeight, alignment: .center)
                                }
                                
                                Text("\(viewModel.currentStyleName) Karate")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color(uiColor: .systemGray5))
                                    .clipShape(Capsule())
                                    .padding(.top, 10)
                            }
                        }
                    }
                    // --- DYNAMIC HEIGHT LOGIC ---
                    // If Celebration: 200 + 139 = 339
                    // If Standard: 200
                    .frame(height: viewModel.showCelebration ? cardHeight + 139 : nil)
                    .frame(minHeight: cardHeight) // Ensure it's at least 200
                    // ----------------------------
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    
                    // --- 4. Action Buttons ---
                    // High-level: Primary actions to start, complete, skip, or continue after celebration.
                    VStack(spacing: 12) {
                        
                        if viewModel.showCelebration {
                            primaryButton(title: "Give me more!", icon: "flame.fill", color: .red) {
                                viewModel.generateKata()
                            }
                        }
                        else if viewModel.generatedKata == nil {
                            HStack(spacing: 12) {
                                primaryButton(title: "Pick My Kata", icon: "play.fill", color: .red) {
                                    viewModel.generateKata()
                                }
                            }
                        }
                        else {
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
                    
                    // --- 5. Today's Progress ---
                    // High-level: Visualizes daily target completion and motivational feedback.
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Today's Progress")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.progressText)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        
                        ProgressView(value: viewModel.progressValue)
                            .tint(.red)
                        
                        Text(viewModel.progressMotivationalText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // --- 6. Stats Grid ---
                    HStack(spacing: 12) {
                        StatCardView(value: viewModel.totalKatasText, label: "Total Katas")
                        StatCardView(value: viewModel.streakText.components(separatedBy: " ").first ?? "0", label: "Current Streak")
                        StatCardView(value: viewModel.longestStreakText, label: "Best Streak")
                    }
                    .padding(.horizontal)

                }
                .padding(.vertical)
            }
            
            // --- LEVEL UP OVERLAY ---
            if viewModel.showLevelUp, let tier = viewModel.newlyUnlockedTier {
                LevelUpOverlay(
                    tier: tier,
                    dismissAction: {
                        viewModel.dismissLevelUp()
                    }
                )
                .zIndex(100)
            }
            
        }
        .animation(.spring(), value: viewModel.showLevelUp)
        .navigationBarHidden(true)
        .onAppear {
            // Load persisted settings and initialize view state.
            viewModel.loadData(context: modelContext)
        }
        .sheet(isPresented: $isShowingStats) {
            StatsView()
        }
    }
    
    // Helper functions
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
            .background(Color(uiColor: .tertiarySystemFill))
            .foregroundStyle(Color.primary)
            .cornerRadius(12)
        }
    }
}

// Preview and Color Extension
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, PracticeLog.self, configurations: config)
    
    let sampleSettings = UserSettings(currentStreak: 7, longestStreak: 12, dailyKataTarget: 5)
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
