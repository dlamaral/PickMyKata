//
//  KarateStyle.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation

// We make our enum conform to:
// 1. String: So we can store its rawValue (e.g., "Shotokan") in SwiftData.
// 2. CaseIterable: This gives us a '.allCases' array, which is
//    perfect for building our style selector in the Settings view.
// 3. Codable: This allows it to be easily encoded/decoded, which is
//    necessary for our StyleExclusion struct.

public enum KarateStyle: String, CaseIterable, Codable {
    case shotokan = "Shotokan"
    case gojuRyu = "Goju-ryu"
    case shitoRyu = "Shito-ryu"
    
    // This helper variable provides a user-friendly name for display.
    // In our case, it's the same as the raw value, but this
    // gives us flexibility if we ever wanted to change it.
    var displayName: String {
        return self.rawValue
    }
}
