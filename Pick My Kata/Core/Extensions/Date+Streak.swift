//
//  Date+Streak.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation

public extension Date {

    // 1. A computed property to get the "start of the day"
    //    (i.e., midnight) for any given Date.
    //    This is crucial for reliably comparing dates, as it
    //    ignores the time component.
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    // 2. A computed property that returns 'true' if the date is
    //    the same calendar day as today.
    var isToday: Bool {
        // We compare the 'startOfDay' for both dates.
        return self.startOfDay == Date().startOfDay
    }

    // 3. A computed property that returns 'true' if the date was
    //    the same calendar day as yesterday.
    var isYesterday: Bool {
        // We get today's startOfDay, subtract one day,
        // and check if it equals our date's startOfDay.
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            // This should never fail
            return false
        }
        return self.startOfDay == yesterday.startOfDay
    }
}
