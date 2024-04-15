//
//  AudioVisualManager.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/15/24.
//

import SwiftUI
import AVKit
import AVFoundation

class AudioVisualManager: ObservableObject {
    private var audioPlayer: AVPlayer?
    var videoPlayer: AVPlayer?
    
    func playAudioWithLocalVideo(audioURLString: String) {
        guard let audioURL = URL(string: audioURLString) else {
            print("Invalid audio URL")
            return
        }
        
        // Initialize the audio player
        audioPlayer = AVPlayer(url: audioURL)
        
        // Access the video from the asset catalog
        guard let path = Bundle.main.path(forResource: "soundWaves", ofType: "mp4") else {
            print("Sound wave video not found")
            return
        }
        let videoURL = URL(fileURLWithPath: path)
        videoPlayer = AVPlayer(url: videoURL)
        
        // Start playback
        audioPlayer?.play()
        videoPlayer?.play()
    }
    
    func stopPlayback() {
        audioPlayer?.pause()
        videoPlayer?.pause()
    }
}
