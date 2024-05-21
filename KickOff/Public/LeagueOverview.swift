//
//  LeagueOverview.swift
//  KickOff
//
//  Created by Anubhav Rawat on 13/05/24.
//

import Foundation
import SwiftUI
//get parameters 
enum LeagueOverviewCustomTabState: String{
    case fixtures, stats, table
}

struct CustomTabView: View{
    
    @Binding var tabState: LeagueOverviewCustomTabState
    
    var body: some View{
        VStack{
            HStack{
                Text("Fixtures")
                    .font(.system(size: tabState == .fixtures ? 22 : 18, weight: tabState == .fixtures ? .black : .bold))
                Text("Table")
                    .font(.system(size: tabState == .table ? 22 : 18, weight: tabState == .table ? .black : .bold))
                Text("stats")
                    .font(.system(size: tabState == .stats ? 22 : 18, weight: tabState == .stats ? .black : .bold))
            }
        }
    }
}

class LeagueOverviewViewModel: ObservableObject{
    var league: League
    
    @Published var fixtures: [Fixtures] = []
    @Published var errorMessage: String = ""
    
    init(league: League){
        self.league = league
    }
    
    func getFixturesForLeague() async {
        do{
            let fixtures = try await URLSession.shared.asyncRequest(
                urlString: Constants.getFixturesByLeagueID(),
                encodingObj: [Fixtures].self,
                httpMethod: "GET",
                headers: nil,
                body: nil,
                queryParams: ["leagueID": "\(league.leagueID)"]
            )
            DispatchQueue.main.async{
                self.fixtures = fixtures
            }
        }catch{
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

struct LeagueOverview: View {
    
    @ObservedObject var viewModel: LeagueOverviewViewModel
    
    var body: some View {
        VStack{
            if !viewModel.errorMessage.isEmpty{
                Text(viewModel.errorMessage)
            }else if !viewModel.fixtures.isEmpty{
                
//                showing all fixtures only for now.
                ScrollView{
                    ForEach(viewModel.fixtures, id: \.fixtureID){fixture in
                        NavigationLink {
                            FixtureDetailView(fixtureID: fixture.fixtureID)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20).fill(.orange.opacity(0.5)).frame(height: 40)
                                Text("\(fixture.homeTeamName) vs \(fixture.awayTeamName)")
                            }
                        }
                    }
                }
            }else{
                Text("fetching fixtures for \(viewModel.league.name)")
            }
        }
        .onAppear(perform: {
            Task{
                await viewModel.getFixturesForLeague()
            }
        })
    }
}

