//
//  Dashboard.swift
//  KickOff
//
//  Created by Anubhav Rawat on 19/05/24.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject{
    @Published var todayFixtures: [TodayFixture] = []
    
    func getTodayFixtures() async{
        do{
            let fixtures = try await URLSession.shared.asyncRequest(
                urlString: Constants.getTodayFixtures(),
                encodingObj: [TodayFixture].self,
                httpMethod: "GET",
                headers: nil,
                body: nil,
                queryParams: nil
            )
            
            DispatchQueue.main.async{
                self.todayFixtures = fixtures
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

struct Dashboard: View {
    
    @StateObject var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                todaysFixtures
            }
        }
    }
    
    @ViewBuilder
    var todaysFixtures: some View{
        VStack{
            if viewModel.todayFixtures.isEmpty{
                Text("no fixtures for today")
            }else{
                ForEach(viewModel.todayFixtures, id: \.league){ league in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(league.fixtures, id: \.fixtureID){fixture in
                                
                                NavigationLink {
                                    FixtureDetailView(fixtureID: fixture.fixtureID)
                                } label: {
                                    VStack{
                                        HStack{
                                            if let homeTeamLogo = fixture.homeTeamLogo{
                                                AsyncImage(url: URL(string: homeTeamLogo)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 60, height: 60)
                                                } placeholder: {
                                                    Circle().fill(.orange)
                                                        .frame(width: 60)
                                                }

                                            }
                                            
                                            Text("VS")
                                                .font(.system(size: 20, weight: .black))
                                            
                                            if let awayTeamLogo = fixture.awayTeamLogo{
                                                AsyncImage(url: URL(string: awayTeamLogo)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 60, height: 60)
                                                } placeholder: {
                                                    Circle().fill(.orange)
                                                        .frame(width: 60)
                                                }

                                            }
                                        }
                                        Text("\(fixture.homeTeamName) vs \(fixture.awayTeamName)")
                                    }
                                    .foregroundStyle(.black)
                                    .background(
                                        Color.gray
                                    )
                                }

                                
                                
                            }
                        }
                    }
                    
                }
            }
        }
        .onAppear{
            Task{
                await viewModel.getTodayFixtures()
            }
        }
    }
}
