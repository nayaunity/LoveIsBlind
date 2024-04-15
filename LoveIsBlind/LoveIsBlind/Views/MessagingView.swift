//
//  MessagingView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/17/24.
//

import SwiftUI

struct MessagingView: View {
    @State private var messageText: String = ""

    var daterName: String
    
    var body: some View {
        ZStack {
            Image("ChatViewBackground") // Ensure this image is in your asset catalog
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Messages placeholder
                Text(daterName)
                    .font(.system(size: 70, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
                    .padding(.top, 50)

                VStack(spacing: 10) {
                    HStack {
                        Text("Hello, how are you?")
                            .padding()
                            .background(Color(hex: "#991129"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .font(.system(size: 19, weight: .light, design: .default))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Spacer()
                        Text("I'm great, thanks! And you?")
                            .padding()
                            .background(Color(hex: "#55189B"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .font(.system(size: 19, weight: .light, design: .default))
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("I'm doing well, just working on SwiftUI.")
                            .padding()
                            .background(Color(hex: "#991129"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .font(.system(size: 19, weight: .light, design: .default))
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Aesthetic mock input field
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white.opacity(0.2))
                        TextField("Type a message...", text: $messageText)
                            .padding(10)
                            .padding(.horizontal, 25) // Extra horizontal padding for inner text
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    Button(action: {}) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(hex: "#55189B"))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 8)
                    .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.bottom, 80)
            }
        }
//        .navigationBarTitle("Chat", displayMode: .inline)
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView(daterName: "Theo")
    }
}
