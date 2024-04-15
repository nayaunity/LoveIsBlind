//
//  RecordBioView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//

import SwiftUI
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct RecordBioView: View {
    @ObservedObject var audioRecorder = AudioRecorder()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                Text("Tap the button to record your bio. If your application is approved, this will be the first thing dates hear from you, so make it good!")
                    .font(.system(size: 30, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                Button(action: {
                    self.audioRecorder.toggleRecording()
                }) {
                    Image(systemName: self.audioRecorder.recording ? "stop.circle.fill" : "mic.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .clipped()
                        .foregroundColor(Color(hex: "#37BEFD"))
                }
                      
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                if audioRecorder.hasRecording {
                    Button("Play Recording") {
                        self.audioRecorder.playRecording()
                    }
                    .padding()
                    .font(.system(size: 20, weight: .light, design: .default))
                    .foregroundColor(Color(.white))
                }

                Spacer()

                Button("Submit Voice Recording") {
                    submitVoiceRecording { message in
                        alertMessage = message
                        showAlert = true
                    }
                }
                .disabled(!audioRecorder.hasRecording)
                .font(.system(size: 35, weight: .ultraLight, design: .default))
                .foregroundColor(.white)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Submission Status"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                    if alertMessage == "Thank you! You will hear back soon." {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
            .padding()
//            .navigationBarTitle("Record Your Bio", displayMode: .inline)
            .onAppear {
                audioRecorder.setupAudioSession()
                audioRecorder.requestMicrophonePermission()
            }
            .background(
                Image("ApplicationBackground")
                    .resizable() // Make the image resizable
                    .aspectRatio(contentMode: .fill) // Fill the screen, potentially cropping the image
                    .edgesIgnoringSafeArea(.all)
            )
        }
        
    }
    
    func submitVoiceRecording(completion: @escaping (String) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion("User not logged in.")
            return
        }
        
        let userEmail = currentUser.email ?? "No email found"
        let userID = currentUser.uid

        fetchUserSex { userSex in
            guard let recordingURL = self.audioRecorder.fetchRecording(), let userSex = userSex else {
                completion("No recording found or user sex unavailable.")
                return
            }

            let storageRef = Storage.storage().reference().child("recordings/\(UUID().uuidString).m4a")
            storageRef.putFile(from: recordingURL, metadata: nil) { metadata, error in
                guard error == nil else {
                    completion("Error uploading recording: \(error!.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        completion("Error obtaining recording URL: \(error!.localizedDescription)")
                        return
                    }
                    
                    let db = Firestore.firestore()
                    let batch = db.batch()
                    
                    // Document reference for adding to "daters" collection
                    let daterRef = db.collection("daters").document(userID)
                    batch.setData([
                        "email": userEmail,
                        "sex": userSex,
                        "recordingURL": downloadURL.absoluteString
                    ], forDocument: daterRef)
                    
                    // Document reference for updating "users" collection
                    let userRef = db.collection("users").document(userID)
                    batch.updateData([
                        "bioSubmitted": true
                    ], forDocument: userRef)
                    
                    // Commit the batch
                    batch.commit { error in
                        if let error = error {
                            completion("Error updating user info: \(error.localizedDescription)")
                        } else {
                            do {
                                try Auth.auth().signOut()
                                completion("Thank you! You will hear back soon.")
                            } catch let signOutError {
                                completion("Error signing out: \(signOutError.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchUserSex(completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let userSex = document.data()?["sex"] as? String
                completion(userSex)
            } else {
                completion(nil)
            }
        }
    }
}

// Helper method to toggle recording on and off
extension AudioRecorder {
    func toggleRecording() {
        if recording {
            stopRecording()
        } else {
            startRecording()
        }
    }
}

// Example preview
struct RecordBioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordBioView()
    }
}
