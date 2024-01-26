//
//  SuccessHaptics.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/15/24.
//

import Foundation
import CoreHaptics

struct SuccessHaptics {
    var hapticEngine: CHHapticEngine?
    
    // Checking If Device Support Happtic Feedback
    init() {
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            do {
                hapticEngine = try CHHapticEngine()
            } catch let error {
                print("Error creating haptic engine: \(error.localizedDescription)")
            }
        }
    }
        
    // Creatte Custom Happtic Pattern
    func playCustomHapticPatter() {
        guard let hapticEngine = hapticEngine else { return }
        
        do {
            // Start the haptic engine
            try hapticEngine.start()
            
            // Define haptic events
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
            let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            let hapticEvent2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.15)
            
            // Create a pattern with the events
            let pattern = try CHHapticPattern(events: [hapticEvent, hapticEvent2], parameters: [])
            
            // Create a player and start playing the pattern
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error playing custom haptic pattern: \(error.localizedDescription)")
        }
    }
}
