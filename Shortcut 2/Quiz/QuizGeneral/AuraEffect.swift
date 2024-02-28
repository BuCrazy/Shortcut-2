//
//  AuraEffect.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI
import AVFoundation

struct AuraEffect: View {
    var feedbackColor: Color
    var correctHaptic = SuccessHaptics()
    var incorrectHaptic = FailHaptics()
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        P171_CircleAnimation(feedbackColor: feedbackColor)
            .blendMode(.screen)
            .blur(radius: 28)
            .transition(.opacity)
            .onAppear {
                if feedbackColor == .green {
                    playSound(filename: "CorrectSound", fileExtension: "mp3")
                    correctHaptic.playCustomHapticPatter()
                } else if feedbackColor == .red {
                    playSound(filename: "IncorrectSound", fileExtension: "mp3")
                    incorrectHaptic.playCustomHapticPatter()
                }
            }
    }
    func playSound(filename: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}

#Preview {
    AuraEffect(feedbackColor: .green)
}
