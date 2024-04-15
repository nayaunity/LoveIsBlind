//
//  AuthViewModel.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/16/24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    private var listenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        listenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }

    deinit {
        if let listenerHandle = listenerHandle {
            Auth.auth().removeStateDidChangeListener(listenerHandle)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
