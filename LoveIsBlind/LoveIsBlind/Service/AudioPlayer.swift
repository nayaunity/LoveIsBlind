//
//  AudioPlayer.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/15/24.
//

import SwiftUI
import AVFoundation

class AudioPlayerManager: ObservableObject {
    private var audioPlayer: AVPlayer?
    @Published var isPlaying = false // Tracks if audio is playing

    func playRecording(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL for voice recording")
            return
        }
        
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
        isPlaying = true // Update to true when audio starts playing
        
        // Observe when the audio finishes playing to update isPlaying
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem, queue: .main) { [weak self] _ in
            self?.isPlaying = false
        }
    }
    
    func stopPlaying() {
        audioPlayer?.pause()
        isPlaying = false // Update to false when audio stops
    }
}


