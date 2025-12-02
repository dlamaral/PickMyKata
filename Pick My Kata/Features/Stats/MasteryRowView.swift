//
//  MasteryRowView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftUI

struct MasteryRowView: View {
    let data: KataMasteryData
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Row 1: Name and Rank Icon
            HStack {
                Text(data.kataName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: data.tier.icon)
                    .font(.title3)
                    .foregroundStyle(data.tier.color)
            }
            
            // Row 2: Style Pill and Rank Name
            HStack {
                Text(data.styleName)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(Capsule())
                
                Spacer()
                
                Text(data.tier.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(data.tier.color)
            }
            
            // Row 3: Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .frame(height: 8)
                        .foregroundStyle(Color(uiColor: .systemGray5))
                    
                    // Filled track
                    Capsule()
                        .frame(width: geometry.size.width * CGFloat(data.progressToNextLevel), height: 8)
                        .foregroundStyle(data.tier.color)
                }
            }
            .frame(height: 8)
            
            // Row 4: Stats Text
            HStack {
                Text("Practiced \(data.count) times")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // We show percentage of current tier completion
                Text("\(Int(data.progressToNextLevel * 100))% to next level")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        // Add a clean border like the screenshot
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
        )
    }
}
