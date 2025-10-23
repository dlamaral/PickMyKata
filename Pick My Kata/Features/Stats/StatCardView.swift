//
//  StatCardView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 22/10/2025.
//

import SwiftUI

struct StatCardView: View {
    var value: String
    var label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.red)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        // --- THIS IS THE FIX ---
        // Adapts automatically: White in Light Mode, Dark Grey in Dark Mode
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        // -----------------------
        .cornerRadius(12)
        // Shadow is subtle in Light Mode, invisible in Dark Mode (standard behavior)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
        StatCardView(value: "23", label: "Total Katas")
            .padding()
    }
}
