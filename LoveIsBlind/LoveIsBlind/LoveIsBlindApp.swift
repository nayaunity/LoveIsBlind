//
//  LoveIsBlindApp.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct LoveIsBlindApp: App {
  // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var sessionStore = SessionStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel) // Make sure it's injected here
                .environmentObject(sessionStore) // Assuming sessionStore is also being used
        }
    }
}
