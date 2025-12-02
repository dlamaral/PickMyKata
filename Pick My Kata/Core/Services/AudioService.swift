//
//  AudioService.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 28/11/2025.
//

import Foundation
import AudioToolbox
import UIKit

class AudioService {
    
    static let shared = AudioService()
    
    private init() {}
    
    /// Plays a "Tink" sound and a light tap vibration.
    /// Used when marking a kata as done.
    func playCompletionSound() {
        // System Sound 1057 is a pleasant "Tink"
        AudioServicesPlaySystemSound(1057)
        
        // Light Haptic Impact
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Plays a stronger "Success" sound and a heavy vibration.
    /// Used for Level Ups.
    func playLevelUpSound() {
        // System Sound 1022 is a standard "Success/Confirmation" sound
        AudioServicesPlaySystemSound(1022)
        
        // Success Haptic Notification (Vibration pattern)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Plays a subtle click.
    /// Used when picking a new kata.
    func playClickSound() {
        // Selection haptic (very light)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
