# Love Is Blind - Dating App

## 🌟 Introduction
Based on the popular Netflix show "Love is Blind", this dating app sets out to build connections sight unseen. Just like on the show, once accepted into the the app, users express interest after hearing the voices of their possible matches. Possible matches introduce themselves and express what they're looking for and upon a match, "pods" are created for further messaging. Upon mutual agreement, users meet up for a date which is the first time they would see their match!

## 🎥 Walkthrough
Watch this short video to see the app in action:

[[Love is Blind Dating App - Walkthrough Video]](https://www.instagram.com/reel/C4s_CiZgsj3/?igsh=MWtlamhibG5xNWExZg==)

## 💡 Features

- **Like & Match**: Utilizes Firestore to store and retrieve swipes and matches. Matches are determined based on mutual likes.
- **Voice Recording**: Users can record a personal audio introduction.
- **Audio Playback**: Integrates AVFoundation for playback of user recordings within the app, enhancing the dating experience by making it more personal and engaging.
- **Real-Time Chat**: Once matched, users can send and receive messages in real-time, fostering communication and deeper connections. The messaging system is powered by Firestore to ensure immediate delivery and receipt of messages.
- **Privacy & Security**: Secure user authentication using Firebase Auth, supporting email and password credentials.

## 🛠 Technical Stack

- **UI Framework**: SwiftUI
- **Backend**: Firebase Firestore, Firebase Authentication
- **Image Handling**: SDWebImageSwiftUI
- **Dependency Management**: CocoaPods

## 🚀 Getting Started

Follow these instructions to set up the project on your local machine for development and testing purposes.

### Prerequisites

- macOS
- Xcode
- An active Apple developer account

### Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/yourusername/LoveIsBlind.git
   cd LoveIsBlind
