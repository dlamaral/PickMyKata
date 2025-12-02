//
//  LevelUpOverlay.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftUI

struct LevelUpOverlay: View {
    let tier: MasteryTier
    let dismissAction: () -> Void
    
    // Animation States
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 1. Dimmed Background
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { dismissAction() }
            
            // 2. Confetti Burst (Behind the card)
            if isAnimating {
                ConfettiView()
                    .transition(.opacity.combined(with: .scale))
            }
            
            // 3. The Main Card
            VStack(spacing: 24) {
                
                // Header
                Text("Level Up!")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(.white)
                    .shadow(color: tier.color.opacity(0.8), radius: 10)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                // Icon Circle (Smaller now)
                ZStack {
                    Circle()
                        .fill(tier.color)
                        .frame(width: 90, height: 90) // Reduced from 120
                        .shadow(color: tier.color.opacity(0.6), radius: 20)
                    
                    Image(systemName: tier.icon)
                        .font(.system(size: 40)) // Reduced from 60
                        .foregroundStyle(.white)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.1), value: isAnimating)
                
                // Text Content
                VStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Text("You are now a")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(tier.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(tier.color)
                    }
                    
                    // The Motivational Sentence
                    Text(tier.message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true) // Prevent truncation
                }
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut.delay(0.2), value: isAnimating)
                
                // Button
                Button(action: dismissAction) {
                    Text("Awesome!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(tier.color)
                        .clipShape(Capsule())
                        .shadow(color: tier.color.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .padding(.top, 10)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut.delay(0.4), value: isAnimating)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .shadow(radius: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(tier.color, lineWidth: 3)
                    )
            )
            .padding(.horizontal, 40)
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LevelUpOverlay(
        tier: MasteryUtils.getTier(for: 55), // Competitor
        dismissAction: {}
    )
}
