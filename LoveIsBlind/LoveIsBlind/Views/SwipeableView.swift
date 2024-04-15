
//
//  SwipeableView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/13/24.
//

import SwiftUI
import AVFoundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct SwipeableView: View {
    @State private var daters = [Dater]()
    @State private var currentIndex = 0
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var showNoMoreDatersMessage = false
    @State private var backgroundImageName = "MaleSilhouette2" // Default background

    
    init(daters: [Dater] = []) {
        _daters = State(initialValue: daters)
    }
    
    private func fetchSwipedDatersIds(completion: @escaping ([String]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        Firestore.firestore().collection("swipes").whereField("swiper", isEqualTo: userId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents in 'swipes'")
                completion([])
                return
            }
            
            let ids = documents.compactMap { $0.data()["swipedOn"] as? String }
            completion(ids)
        }
    }

    private func fetchCurrentDaterAndOppositeSexDaters() {
        guard let currentDaterId = Auth.auth().currentUser?.uid else {
            print("Dater not found")
            return
        }

        Firestore.firestore().collection("daters").document(currentDaterId).getDocument { document, error in
            if let document = document, document.exists, let sex = document.data()?["sex"] as? String {
                self.fetchDaters(oppositeSex: sex == "Male" ? "Female" : "Male")
            } else {
                print("Document does not exist or failed to fetch current dater document.")
            }
        }
    }

    private func fetchDaters(oppositeSex: String) {
        fetchSwipedDatersIds { swipedIds in
            Firestore.firestore().collection("daters")
                .whereField("sex", isEqualTo: oppositeSex)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching daters: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        self.showNoMoreDatersMessage = true
                        return
                    }

                    let group = DispatchGroup()
                    var fetchedDaters: [Dater] = []

                    documents.forEach { document in
                        let id = document.documentID
                        guard !swipedIds.contains(id) else { return }
                        
                        let data = document.data()
                        var dater = Dater(id: id, email: data["email"] as? String ?? "", sex: data["sex"] as? String ?? "", recordingURL: data["recordingURL"] as? String ?? "")
                        
                        group.enter()
                        // Fetch the name from the "users" collection
                        Firestore.firestore().collection("users").document(id).getDocument { userSnapshot, userError in
                            if let userData = userSnapshot?.data(), let name = userData["name"] as? String {
                                dater.name = name
                            }
                            fetchedDaters.append(dater)
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        self.daters = fetchedDaters.sorted { $0.name < $1.name }
                        
                        if fetchedDaters.isEmpty {
                            self.showNoMoreDatersMessage = true
                        }
                    }
                }
        }
    }



    var body: some View {
        ZStack {
            Image(backgroundImageName)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if showNoMoreDatersMessage {
                    Text("No more daters to show")
                } else if !daters.isEmpty && currentIndex < daters.count {
                    let dater = daters[currentIndex]
                    VStack {
                        Text(dater.name)
                            .font(.system(size: 80, weight: .ultraLight, design: .default))
                            .padding(.top, 100) // Adds padding at the top
                            .foregroundColor(Color(hex: "#d1ae45"))
                        
                        Spacer()
                        if audioPlayerManager.isPlaying {
                            SoundWaveView(isPlaying: $audioPlayerManager.isPlaying)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 3)
                        } else {
                            Button(action: {
                                audioPlayerManager.playRecording(urlString: dater.recordingURL)
                            }) {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(.black)
                                    .opacity(0.3)
                                    .padding(.leading, 40)
//                                    .padding(.top, 1)
                            }
                        }
                        Spacer()
                        HStack {
                            Button(action: { self.swipeLeft() }) {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(hex: "#8B2828"))
                            }
                            Button(action: { self.swipeRight(dater: dater) }) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(red: 116/255, green: 47/255, blue: 178/255))
                            }
                        }
                        .padding(.bottom, 100) // Adds padding at the top
                    }
                } else {
                    Text("No more daters to show")
                }
            }
            .onAppear(perform: fetchCurrentDaterAndOppositeSexDaters)
            .onDisappear {
                audioPlayerManager.stopPlaying()
            }
        }
        
    }
    
    private func fetchCurrentDaterAndSetBackground() {
        guard let currentDaterId = Auth.auth().currentUser?.uid else {
            print("Dater not found- please check for additional errors. ")
            return
        }

        Firestore.firestore().collection("daters").document(currentDaterId).getDocument { document, error in
            if let document = document, document.exists, let sex = document.data()?["sex"] as? String {
                // Set the background image based on the user's sex
                backgroundImageName = sex == "Male" ? "FemaleSilhoette2" : "MaleSilhouette2"
                self.fetchDaters(oppositeSex: sex == "Male" ? "Female" : "Male")
            } else {
                print("Document does not exist or failed to fetch current dater document.")
            }
        }
    }

    private func swipeLeft() {
        if currentIndex < daters.count {
            recordSwipe(action: "dislike", swipedOnId: daters[currentIndex].id)
            moveToNextDater()
        }
    }

    private func swipeRight(dater: Dater) {
        if currentIndex < daters.count {
            recordSwipe(action: "like", swipedOnId: dater.id)
            moveToNextDater()
        }
    }

    private func moveToNextDater() {
        if currentIndex < daters.count - 1 {
            currentIndex += 1
        } else {
            // Handle the scenario where there are no more daters to show
            showNoMoreDatersMessage = true
        }
    }

    private func recordSwipe(action: String, swipedOnId: String) {
        guard let swiperId = Auth.auth().currentUser?.uid else { return }
        let swipeData: [String: Any] = [
            "action": action,
            "swiper": swiperId,
            "swipedOn": swipedOnId,
            "timestamp": Timestamp()
        ]
        
        Firestore.firestore().collection("swipes").addDocument(data: swipeData) { error in
            if let error = error {
                print("Error recording swipe: \(error.localizedDescription)")
            } else {
                print("\(action.capitalized) recorded for user \(swipedOnId)")
            }
        }
    }
}

struct SwipeableView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableView(daters: [
            Dater(id: "1", email: "user1@example.com", sex: "Female", recordingURL: "https://example.com/recording1.m4a", name: "Theo"),
            Dater(id: "2", email: "user2@example.com", sex: "Male", recordingURL: "https://example.com/recording2.m4a", name: "Paulo")
        ])
    }
}
