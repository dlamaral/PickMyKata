//
//  StyleExclusion.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation

// 1. We conform to 'Codable' so SwiftData can easily
//    serialize and deserialize this struct for storage.
// 2. We conform to 'Hashable' so SwiftUI can use it
//    in 'List' and 'ForEach' views efficiently.
public struct StyleExclusion: Codable, Hashable {
    
    // We store the 'rawValue' of the style (e.g., "Shotokan")
    let styleName: String
    
    // An array of kata names the user has excluded for that style.
    var excludedKatas: [String]
}
