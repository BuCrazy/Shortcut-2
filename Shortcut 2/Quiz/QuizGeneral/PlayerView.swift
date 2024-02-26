//
//  PlayerView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI
import AVKit
import AVFoundation

struct PlayerView: UIViewControllerRepresentable {
    let url: URL
    let player = AVPlayer()
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        player.play()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }
    
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(url: URL(string: "https://playphrase.me/#/search?q=tesla+&pos=0")!/*, shouldStopVideo: .constant(false)*/)
    }
}
