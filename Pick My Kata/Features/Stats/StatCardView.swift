//
//  StatCardView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 22/10/2025.
//

import SwiftUI

// This is a new reusable view for the stats grid.
// We can create this file right inside the 'Generator' folder
// or make a new 'Core/Views' folder.
struct StatCardView: View {
    var value: String
    var label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red) // Matching the "23" in the design
            
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    StatCardView(value: "23", label: "Total Katas")
        .padding()
        .background(Color.gray.opacity(0.1))
}
