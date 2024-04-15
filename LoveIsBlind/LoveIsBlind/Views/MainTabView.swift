//
//  MainTabView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/16/24.
//

import SwiftUI

// Define an enumeration to represent each tab.
enum Tab {
    case logout
    case date
    case matches
}

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .date // Default to the "Date" tab

    var body: some View {
        TabView(selection: $selectedTab) { // Use the selection parameter to control the active tab
            
            Button("Logout") {
                authViewModel.signOut()
            }
            .tabItem {
                Label("Logout", systemImage: "door.right.hand.open")
            }
            .tag(Tab.logout) // Tag this view with its corresponding tab enum value
            
            SwipeableView()
                .tabItem {
                    Label("Date", systemImage: "calendar")
                }
                .tag(Tab.date) // Tag this view with its corresponding tab enum value

            MatchesView()
                .tabItem {
                    Label("Matches", systemImage: "heart.fill")
                }
                .tag(Tab.matches) // Tag this view with its corresponding tab enum value
        }
    }
}
