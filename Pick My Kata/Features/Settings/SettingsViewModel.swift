//
//  SettingsViewModel.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // 1. We publish the list of all available styles.
    //    We get this directly from our enum's 'allCases'.
    @Published var allStyles: [KarateStyle] = KarateStyle.allCases
    
    // 2. We publish the *currently selected style*.
    //    The View's Picker will bind directly to this.
    @Published var selectedStyle: KarateStyle = .shotokan {
        didSet {
            // 3. When the style changes:
            //    a) Save the new style to our database.
            userSettings?.selectedStyle = selectedStyle.rawValue
            //    b) Reload the kata list for the new style.
            loadKataList()
        }
    }
    
    // 4. We publish the list of katas for the 'selectedStyle'.
    @Published var kataList: [String] = []
    
    // MARK: - Private Properties
    
    // A private reference to the user's settings object from SwiftData.
    private var userSettings: UserSettings?
    
    // MARK: - Public Functions
    
    /// Loads the user's settings from the database.
    /// This should be called from the View's `.onAppear`.
    /// - Parameter settings: The UserSettings object from the SwiftData query.
    func loadData(settings: UserSettings) {
        self.userSettings = settings
        
        // 5. Set our published style to match what's saved.
        if let savedStyle = KarateStyle(rawValue: settings.selectedStyle) {
            self.selectedStyle = savedStyle
        }
        
        // 6. Load the kata list for that style.
        loadKataList()
    }
    
    /// Checks if a specific kata is in the user's exclusion list.
    /// The View will call this for each row to show/hide the checkmark.
    /// - Parameter kata: The name of the kata to check.
    /// - Returns: 'true' if the kata is excluded, 'false' otherwise.
    func isKataExcluded(_ kata: String) -> Bool {
        guard let exclusion = getExclusion(for: selectedStyle) else {
            // No exclusion object exists for this style,
            // so the kata cannot be excluded.
            return false
        }
        return exclusion.excludedKatas.contains(kata)
    }
    
    /// Toggles a kata's inclusion/exclusion status.
    /// This is called when a user taps on a kata row.
    /// - Parameter kata: The name of the kata to toggle.
    func toggleExclusion(for kata: String) {
        guard let settings = userSettings else { return }

        // 7. Find or create the exclusion object for the current style.
        var exclusion = getExclusion(for: selectedStyle)
        
        if exclusion == nil {
            // No exclusion object exists for this style yet. Create one.
            let newExclusion = StyleExclusion(styleName: selectedStyle.rawValue, excludedKatas: [])
            // Insert it into the userSettings.
            // Note: SwiftData requires we append to the *array*
            // for the change to be detected.
            settings.exclusionList.append(newExclusion)
            // Now get the reference to the one we just added.
            exclusion = settings.exclusionList.last
        }
        
        guard var exclusion = exclusion else { return }

        // 8. Now, modify the 'excludedKatas' array.
        if let index = exclusion.excludedKatas.firstIndex(of: kata) {
            // It IS in the list. Remove it.
            exclusion.excludedKatas.remove(at: index)
        } else {
            // It is NOT in the list. Add it.
            exclusion.excludedKatas.append(kata)
        }
        
        // 9. We must write the *modified* struct back into the
        //    userSettings array to persist the change.
        if let settingIndex = settings.exclusionList.firstIndex(where: { $0.styleName == selectedStyle.rawValue }) {
            settings.exclusionList[settingIndex] = exclusion
        }
        
        // 10. Manually trigger an objectWillChange.send() to force the
        //     View to reload its list and update the checkmarks.
        self.objectWillChange.send()
    }

    // MARK: - Private Helpers
    
    /// Gets the master kata list for the 'selectedStyle'
    /// and updates the published 'kataList'.
    private func loadKataList() {
        self.kataList = KataProvider.masterList[selectedStyle] ?? []
    }
    
    /// A helper function to find the 'StyleExclusion' object
    /// for a given style from our settings.
    private func getExclusion(for style: KarateStyle) -> StyleExclusion? {
        return userSettings?.exclusionList.first(where: { $0.styleName == style.rawValue })
    }
}
