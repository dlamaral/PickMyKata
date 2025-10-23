//
//  OnboardingView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftUI
import SwiftData

// MARK: - OnboardingView
// Three-step onboarding flow: welcome → benefits → style selection + persistence.
// Uses @AppStorage to gate the main app, and SwiftData to prefill/commit the style.
struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsQuery: [UserSettings]
    
    @State private var currentTab = 0
    @State private var selectedStyle: KarateStyle = .shotokan
    
    // Animation states
    @State private var showBenefit1 = false
    @State private var showBenefit2 = false
    @State private var showBenefit3 = false
    
    let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.9, green: 0.2, blue: 0.2), Color(red: 0.7, green: 0.1, blue: 0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            backgroundGradient.edgesIgnoringSafeArea(.all)
            
            // Particles
            VStack {
                HStack { Circle().fill(.white.opacity(0.2)).frame(width: 6) ; Spacer() }
                Spacer()
                HStack { Spacer(); Circle().fill(.white.opacity(0.2)).frame(width: 10) }
                Spacer()
            }
            .padding(40)
            
            TabView(selection: $currentTab) {
                welcomeScreen.tag(0)
                benefitsScreen.tag(1)
                actionScreen.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentTab)
        }
        .onAppear {
            if let existing = settingsQuery.first,
               let style = KarateStyle(rawValue: existing.selectedStyle) {
                self.selectedStyle = style
            }
        }
        // --- FIX: TRIGGER ANIMATION WHEN TAB CHANGES ---
        .onChange(of: currentTab) { oldValue, newValue in
            if newValue == 1 {
                animateBenefits()
            }
        }
        // -----------------------------------------------
    }
    
    // MARK: - Screen 1: Welcome
    var welcomeScreen: some View {
        VStack(spacing: 40) {
            Spacer()
            ZStack {
                Circle().fill(.white.opacity(0.2)).frame(width: 120, height: 120)
                Image(systemName: "figure.mind.and.body").font(.system(size: 60)).foregroundStyle(.white)
            }
            VStack(spacing: 16) {
                Text("Welcome,\nKarate-ka")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                Text("\"The ultimate aim of karate lies not in victory or defeat, but in the perfection of the character of its participants.\"")
                    .font(.headline).italic().multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9)).padding(.horizontal)
                Text("— Gichin Funakoshi🥋")
                    .font(.headline).foregroundStyle(.white.opacity(0.7)).padding(.top, 8)
            }
            Spacer()
            Button(action: { currentTab = 1 }) {
                HStack { Text("Begin Your Journey"); Image(systemName: "arrow.right") }
                    .font(.headline).foregroundStyle(Color.red).frame(maxWidth: .infinity)
                    .padding().background(Color.white).clipShape(Capsule())
            }
            .padding(.horizontal, 70).padding(.bottom, 50)
        }
    }
    
    // MARK: - Screen 2: Benefits
    var benefitsScreen: some View {
        VStack(spacing: 30) {
            Spacer()

            // Only show if state is true
            if showBenefit1 {
                benefitCard(icon: "stopwatch.fill", color: .blue, title: "Focus Your Mind", desc: "Master each kata with precision and mindfulness")
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
            
            if showBenefit2 {
                benefitCard(icon: "chart.bar.fill", color: .green, title: "Track Progress", desc: "Build consistency and watch your skills grow daily")
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
            
            if showBenefit3 {
                benefitCard(icon: "medal.fill", color: .yellow, title: "Achieve Excellence", desc: "Earn your place among the masters through dedication")
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
            
            Button(action: { currentTab = 2 }) {
                HStack { Text("Next Step"); Image(systemName: "arrow.right") }
                    .font(.headline).foregroundStyle(Color.red).frame(maxWidth: .infinity)
                    .padding().background(Color.white).clipShape(Capsule())
            }
            .padding(.horizontal, 70).padding(.bottom, 50)
            .opacity(showBenefit3 ? 1.0 : 0.0)
            .animation(.easeIn, value: showBenefit3)
        }
        // NOTE: Removed .onAppear from here
    }
    
    // MARK: - Screen 3: Action
    var actionScreen: some View {
        VStack(spacing: 30) {
            Spacer()
            Image(systemName: "figure.martial.arts").font(.system(size: 80)).foregroundStyle(.white)
            VStack(spacing: 10) {
                Text("Select Your Style").font(.largeTitle).fontWeight(.bold).foregroundStyle(.white)
                Text("Choose your primary style to begin. You can change it and select specific Kata later in Settings.")
                    .font(.callout).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.8)).padding(.horizontal, 40)
            }
            VStack(spacing: 12) {
                ForEach(KarateStyle.allCases, id: \.self) { style in
                    Button(action: { selectedStyle = style }) {
                        HStack {
                            Text(style.displayName).font(.headline).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: selectedStyle == style ? "checkmark.circle.fill" : "circle")
                        }
                        .foregroundStyle(selectedStyle == style ? Color.red : Color.primary)
                        .padding().background(Color.white).cornerRadius(12)
                        .opacity(selectedStyle == style ? 1.0 : 0.7)
                    }
                }
            }
            .padding(.horizontal, 70)
            Spacer()
            Button(action: completeOnboarding) {
                Text("I'm ready to start")
                    .font(.headline).foregroundStyle(Color.red).frame(maxWidth: .infinity)
                    .padding().background(Color.white).clipShape(Capsule())
            }
            .padding(.horizontal, 70).padding(.bottom, 50)
        }
    }
    
    // High-level: Orchestrates staggered animations for benefit cards when the benefits tab appears.
    func animateBenefits() {
        // 1. Reset first so they animate in fresh even if user swiped back/forth
        showBenefit1 = false
        showBenefit2 = false
        showBenefit3 = false
        
        // 2. Schedule each animation with a deliberate delay
        
        // Benefit 1: Starts almost immediately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showBenefit1 = true
            }
        }
        
        // Benefit 2: Starts 0.8s later
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showBenefit2 = true
            }
        }
        
        // Benefit 3: Starts 0.8s after that
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showBenefit3 = true
            }
        }
    }
    
    // MARK: - Helper Views
    func benefitCard(icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle().fill(color).frame(width: 50, height: 50)
                Image(systemName: icon).foregroundStyle(.white).font(.title3)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(.white)
                Text(desc).font(.caption).foregroundStyle(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.15)))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
        .padding(.horizontal, 32)
    }
    
    // High-level: Persist selected style and flip the onboarding completion flag.
    func completeOnboarding() {
        let settings = PersistenceService.fetchOrCreateSettings(context: modelContext)
        settings.selectedStyle = selectedStyle.rawValue
        withAnimation { hasCompletedOnboarding = true }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: UserSettings.self, inMemory: true)
}

