//
//  ContentView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionStore: SessionStore // Use to track login and profile completion.
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            // Check if the user is logged in
            if authViewModel.isLoggedIn {
                // Further check if the profile is complete
                if sessionStore.hasCompletedProfile {
                    // Navigate to MainTabView if the profile is complete
                    MainTabView().environmentObject(authViewModel)
                } else {
                    // Navigate to CreateApplicationView if the profile is incomplete
                    CreateApplicationView().environmentObject(sessionStore)
                }
            } else {
                // Show the LoginSignupView if not logged in
                LoginSignupView().environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
