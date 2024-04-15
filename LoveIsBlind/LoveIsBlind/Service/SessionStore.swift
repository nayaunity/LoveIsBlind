//
//  SessionStore.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//
import Foundation
import Firebase
import FirebaseFirestore

class SessionStore: ObservableObject {
    @Published var isUserAuthenticated: AuthState = .undefined
    @Published var hasCompletedProfile = false

    var authRef: Auth!
    private var _authListener: AuthStateDidChangeListenerHandle!

    init(auth: Auth = .auth()) {
        self.authRef = auth
        
        _authListener = self.authRef.addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("User is signed in with uid:", user.uid)
                self.isUserAuthenticated = .signedIn
                self.checkUserProfileCompletion(uid: user.uid)
            } else {
                print("User is not signed in.")
                self.isUserAuthenticated = .signedOut
                self.hasCompletedProfile = false
            }
        }
    }
    
    func signOut() {
        do {
            try authRef.signOut()
//            self.hasCompletedProfile = false
        } catch {
            print("Error signing out")
        }
    }

    private func checkUserProfileCompletion(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    // Document exists, check if the profile is completed.
                    let data = document.data()
                    self.hasCompletedProfile = data?["profileCompleted"] as? Bool ?? false
                    print("Profile check: Document found, profile completed? \(self.hasCompletedProfile)")
                } else {
                    // Document doesn't exist or error fetching it. Assume profile is not completed.
                    self.hasCompletedProfile = false
                    print("Profile check: Document does not exist or error: \(error?.localizedDescription ?? "No details"), assuming profile is not completed.")
                }
            }
        }
    }
    
    func manuallyCheckProfileCompletion(for uid: String) {
        checkUserProfileCompletion(uid: uid)
    }
    
    enum AuthState {
        case signedIn
        case signedOut
        case undefined
    }
}
