//
//  LocalPlayer.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/16/25.
//

import SwiftUI
import AVKit
import AVFoundation

struct LocalPlayer: UIViewControllerRepresentable {
    let videoName: String  // Name of the video file
    let player = AVPlayer()
    var hideControls: Bool = true
    var isLooping: Bool = true
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    var contentOffset: CGPoint = .zero
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Set the background color
        controller.view.backgroundColor = UIColor(named: "appBG")
        controller.videoGravity = videoGravity
        
        
        //Remove safe area insets
        controller.view.insetsLayoutMarginsFromSafeArea = false
        controller.view.layoutMargins = .zero

        
        // Get the URL for the local video file
        if let videoURL = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            let playerItem = AVPlayerItem(url: videoURL)
            player.replaceCurrentItem(with: playerItem)
            
            // Set up looping if specified
            if isLooping {
                // Add observer for video end
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: playerItem,
                    queue: .main) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                }
            player.play()
        }
        
      
       


        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.view.backgroundColor = UIColor(named: "appBG")
        uiViewController.videoGravity = videoGravity
        
        // Ensure margins stay removed
        uiViewController.view.insetsLayoutMarginsFromSafeArea = false
        uiViewController.view.layoutMargins = .zero

        

    }
}


struct LocalPlayer_Previews: PreviewProvider {
    static var previews: some View {
        LocalPlayer(videoName: "sample_video")
    }
}
