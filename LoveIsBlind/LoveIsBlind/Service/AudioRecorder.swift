//
//  AudioRecorder.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    @Published var recording = false
    @Published var playback = false
    @Published var hasRecording = false  // Indicates if there's a recording available for playback
    
    override init() {
        super.init()
        fetchRecording()
    }

    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone permission granted")
                } else {
                    print("Microphone permission denied")
                }
            }
        }
    }
    
    func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to set up the audio session: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("userBioRecording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            recording = true
            hasRecording = false  // Reset when a new recording starts
        } catch {
            print("Could not start recording")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        recording = false
        hasRecording = true  // A recording is now available for playback
        fetchRecording()
    }

    func playRecording() {
        if let audioFilename = fetchRecording() {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                audioPlayer?.play()
                playback = true
            } catch {
                print("Playback failed.")
            }
        }
    }
    
    func fetchRecording() -> URL? {
        let path = getDocumentsDirectory().appendingPathComponent("userBioRecording.m4a")
        return FileManager.default.fileExists(atPath: path.path) ? path : nil
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording()
        }
        hasRecording = flag
    }
}
