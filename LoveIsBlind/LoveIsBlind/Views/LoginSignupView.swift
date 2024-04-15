//  LoginSignupView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginSignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var showCreateApplicationView = false
    @State private var showMainTabView = false
    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(hex: "#E3D6F0"))
                        .cornerRadius(20)
                        .foregroundColor(Color(red: 0/255, green: 0/255, blue: 0/255))
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(hex: "#E3D6F0"))
//                        .opacity(0.7)
                        .cornerRadius(20)
                        .foregroundColor(Color(red: 109/255, green: 65/255, blue: 42/255))

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Button("Sign Up") {
                        self.signUp()
                    }
                    .foregroundColor(Color(red: 226/255, green: 193/255, blue: 255/255))
                    .cornerRadius(10)
                    .padding(.top, 20)

                    Button("Login") {
                        self.login(email: self.email, password: self.password)
                    }
                    .foregroundColor(Color(red: 226/255, green: 193/255, blue: 255/255))
                    .cornerRadius(10)
                    .padding(.top, 20)
                }
                .padding(.top, 480)
            }
            .background(
                Image("LoveIsBlindCover5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
            .background(Color(red: 92/255, green: 50/255, blue: 168/255))
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Login or Sign Up")
            .navigationBarHidden(true)
            .onChange(of: sessionStore.isUserAuthenticated) { _ in
                if sessionStore.isUserAuthenticated == .signedIn {
                    DispatchQueue.main.async {
                        if self.sessionStore.hasCompletedProfile {
                            self.showMainTabView = true
                        } else {
                            self.showCreateApplicationView = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateApplicationView) {
            CreateApplicationView()
        }
        .onAppear {
            self.checkProfileCompletion()
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if authResult?.user != nil, error == nil {
                    print("Sign up successful")
                    // Update: Directly showing CreateApplicationView after sign-up.
                    self.showCreateApplicationView = true
                } else {
                    self.errorMessage = error?.localizedDescription ?? "An unknown error occurred"
                }
            }
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Login error: \(error.localizedDescription)"
                } else {
                    self.showMainTabView = true
                }
            }
        }
    }
    
    func checkProfileCompletion() {
        if authViewModel.isLoggedIn && !sessionStore.hasCompletedProfile {
            showCreateApplicationView = true
        } else if authViewModel.isLoggedIn {
            // User is logged in and has a completed profile, navigate accordingly.
            // This might mean setting another state variable to trigger navigation to the main app interface.
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
            .environmentObject(SessionStore()) // Provide a dummy or mock SessionStore
            .environmentObject(AuthViewModel()) // Provide a dummy or mock AuthViewModel
    }
}



