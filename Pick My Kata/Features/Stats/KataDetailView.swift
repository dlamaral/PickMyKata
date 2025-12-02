//
//  KataDetailView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 02/12/2025.
//

import SwiftUI

struct KataDetailView: View {
    let data: KataMasteryData
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // --- 1. Header Card ---
                VStack(spacing: 16) {
                    Image(systemName: data.tier.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    VStack(spacing: 4) {
                        Text(data.tier.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Current Rank")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    // Progress Bar within current rank
                    VStack(spacing: 8) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.black.opacity(0.2))
                                    .frame(height: 10)
                                
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width * CGFloat(data.progressToNextLevel), height: 10)
                            }
                        }
                        .frame(height: 10)
                        
                        // Motivational Text
                        if data.tier.upperBound == Int.max {
                            Text("Maximum Rank Achieved")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.9))
                        } else {
                            let remaining = data.tier.upperBound - data.count
                            Text("\(remaining) more katas to \(getNextTierName()) 🏆")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(30)
                .background(data.tier.color)
                .cornerRadius(25)
                .shadow(color: data.tier.color.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                
                // --- 2. Rank Progression List ---
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rank Progression")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(MasteryUtils.allTiers) { tier in
                            ProgressionRow(tier: tier, currentCount: data.count)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(data.kataName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private func getNextTierName() -> String {
        guard let index = MasteryUtils.allTiers.firstIndex(of: data.tier),
              index + 1 < MasteryUtils.allTiers.count else {
            return "Next Rank"
        }
        return MasteryUtils.allTiers[index + 1].title
    }
}

// --- Helper View for the List Items ---
struct ProgressionRow: View {
    let tier: MasteryTier
    let currentCount: Int
    
    var body: some View {
        let isCompleted = currentCount >= tier.upperBound
        let isCurrent = currentCount >= tier.lowerBound && currentCount < tier.upperBound
        let isLocked = currentCount < tier.lowerBound
        
        HStack {
            // Icon
            ZStack {
                Circle()
                    .fill(isLocked ? Color(uiColor: .systemGray5) : Color.white)
                    .frame(width: 44, height: 44)
                
                Image(systemName: tier.icon)
                    .font(.title3)
                    .foregroundStyle(isLocked ? .gray : tier.color)
                    .opacity(isLocked ? 0.5 : 1.0)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tier.title)
                    .font(.headline)
                    .foregroundStyle(isLocked ? .secondary : .primary)
                
                let rangeText = tier.upperBound == Int.max ? "\(tier.lowerBound)+ Katas" : "\(tier.lowerBound)-\(tier.upperBound - 1) Katas"
                Text(rangeText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Status Indicator
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundStyle(.green)
            } else if isCurrent {
                Text("Current")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(tier.color)
                    .clipShape(Capsule())
            } else {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.gray.opacity(0.4))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrent ? tier.color.opacity(0.1) : Color(uiColor: .secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrent ? tier.color : Color(uiColor: .systemGray5), lineWidth: isCurrent ? 2 : 1)
        )
    }
}

