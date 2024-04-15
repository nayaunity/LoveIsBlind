//
//  MatchesViewModel.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/16/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MatchesViewModel: ObservableObject {
    @Published var matches: [User] = []

    func fetchMatches() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("swipes")
            .whereField("swiper", isEqualTo: currentUserID)
            .whereField("action", isEqualTo: "like")
            .getDocuments { [weak self] (snapshot, error) in
                if let documents = snapshot?.documents {
                    let matchedIDs = documents.compactMap { $0.data()["swipedOn"] as? String }
                    self?.fetchUserDetails(for: matchedIDs)
                }
            }
    }

    private func fetchUserDetails(for ids: [String]) {
        ids.forEach { id in
            Firestore.firestore().collection("users").document(id).getDocument { [weak self] (document, error) in
                if let userData = document?.data(), let name = userData["name"] as? String {
                    let newUser = User(id: id, name: name)
                    DispatchQueue.main.async {
                        self?.matches.append(newUser)
                    }
                }
            }
        }
    }
}
