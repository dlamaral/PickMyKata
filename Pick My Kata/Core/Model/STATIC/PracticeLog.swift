//
//  PracticeLog.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 22/10/2025.
//

import Foundation
import SwiftData

// 1. We define a new model to store a record
//    of every completed practice.
@Model
public final class PracticeLog {
    
    // 2. The name of the kata that was practiced.
    var kataName: String
    
    // 3. The exact date and time the user tapped "Complete".
    var datePracticed: Date
    
    public init(kataName: String, datePracticed: Date) {
        self.kataName = kataName
        self.datePracticed = datePracticed
    }
}
