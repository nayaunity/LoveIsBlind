//
//  MatchesView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/16/24.
//

import SwiftUI

struct MatchesView: View {
    @ObservedObject var viewModel = MatchesViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Image("YourPodsHeadline")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.matches, id: \.id) { match in
                            NavigationLink(destination: MessagingView(daterName: match.name)) {
                                HStack {
                                    Hexagon()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 100, height: 100 * sqrt(3) / 2)
                                        .rotationEffect(Angle(degrees: 90))
                                    Spacer()
                                    Text(match.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Hexagon()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 100, height: 100 * sqrt(3) / 2)
                                        .rotationEffect(Angle(degrees: -90))
                                }
                                .padding(.vertical, 10)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            }
                        }


                    }
                }
                .padding(.top, 175)
            }
            .onAppear {
                viewModel.fetchMatches()
            }
        }
    }
}



struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock users
        let mockUsers = [
            User(id: "1", name: "Alex"),
            User(id: "2", name: "Jamie"),
            User(id: "3", name: "Jordan"),
            User(id: "4", name: "Casey")
        ]

        // Instantiate the ViewModel with mock data
        let viewModel = MatchesViewModel()
        viewModel.matches = mockUsers

        // Return MatchesView with the ViewModel
        return MatchesView(viewModel: viewModel)
    }
}


