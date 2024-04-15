//  SoundWaveView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/15/24.
//

import SwiftUI

// Define a SoundBarView for individual bars
struct SoundBarView: View {
    let color: Color
    let minHeightScale: Double
    @Binding var isPlaying: Bool
    
    @State private var animate = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .frame(width: 8, height: 100)
            .foregroundColor(color)
            .scaleEffect(y: animate ? 1 : minHeightScale, anchor: .bottom)
            .onReceive([self.isPlaying].publisher.first()) { (isPlaying) in
                if isPlaying {
                    withAnimation(Animation.easeInOut(duration: 0.6 + Double.random(in: 0...0.4)).repeatForever(autoreverses: true)) {
                        self.animate = true
                    }
                } else {
                    self.animate = false
                }
            }
    }
}

// Updated SoundWaveView to use SoundBarView
struct SoundWaveView: View {
    @Binding var isPlaying: Bool // Add this

    let colors: [Color] = [
        Color(hex: "#8B2828"),
        Color(red: 54/255, green: 14/255, blue: 85/255),
        Color(red: 116/255, green: 47/255, blue: 178/255),
        Color(red: 95/255, green: 129/255, blue: 220/255),
        Color(red: 60/255, green: 183/255, blue: 250/255)
    ]
    let minHeightScales = [0.5, 0.3, 0.7, 0.4, 0.6, 0.5, 0.3, 0.7, 0.4, 0.6, 0.5]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<11) { index in
                SoundBarView(color: colors[index % colors.count], minHeightScale: minHeightScales[index % minHeightScales.count], isPlaying: $isPlaying)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
        .background(Color.clear)
    }
}

//struct SoundWaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundWaveView(isPlaying: true)
//    }
//}


//
//struct SoundWaveView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200)) // Set a default frame
//
//        guard let path = Bundle.main.url(forResource: "soundWaves", withExtension: "mp4") else {
//            print("Video file not found")
//            return view
//        }
//
//        print("Video file found at path: \(path)")
//
//        let player = AVPlayer(url: path)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(playerLayer)
//
//        player.play()
//
//        // Loop the video
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
//            player.seek(to: CMTime.zero)
//            player.play()
//        }
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
