//
//  LeagueDetailView.swift
//  KickOff
//
//  Created by Anubhav Rawat on 15/05/24.
//

import Foundation
import SwiftUI

class FixtureDetailViewModel: ObservableObject{
    
    @Published var detailFixture: DetailFixture? = nil
    
    func getDetailFixture(fixtureID: Int) async {
        do{
           let newDetailFixture = try await URLSession.shared.asyncRequest(
                urlString: Constants.getDetailFixtureByID(),
                encodingObj: DetailFixture.self,
                httpMethod: "GET",
                headers: nil,
                body: nil,
                queryParams: ["fixtureID": "\(fixtureID)"]
            )
            DispatchQueue.main.async{
                self.detailFixture = newDetailFixture
//                print("home team grids")
//                for player in newDetailFixture.homeTeamLineupStartingXI{
//                    print("\(player.name) playing in \(player.grid ?? "no grid")")
//                }
                
//                print("away team grid")
//                for player in newDetailFixture.awayTeamLineupStartingXI{
//                    print("\(player.name) playing in \(player.grid ?? "no grid")")
//                }
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

struct FixtureDetailView: View {
    
    var fixtureID: Int
    
    @StateObject var viewModel = FixtureDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50){
                if let detailFixture = viewModel.detailFixture{
                    
    //               some fixture details like referee, date, venue and city, if available, show on the map. match status, league name and logo on top. season and round total goals for each team. Should be the header of this page.
                    Text("referee \(detailFixture.detailedFixture.referee) time \(detailFixture.detailedFixture.date) \(detailFixture.detailedFixture.timeZone) venue: \(detailFixture.detailedFixture.venue) \(detailFixture.detailedFixture.city) league: \(detailFixture.detailedFixture.leagueName) \(detailFixture.detailedFixture.leagueCountry) logo \(detailFixture.detailedFixture.leagueLogo ?? "") flag \(detailFixture.detailedFixture.leagueFlag ?? "")")
                    
    //              the lineups as shown in games. with jersy number and names on the pitch. the positions to be determined by the grid string. coach name and images below that. And below that will be the substitutes for each team.
                    
                    VStack(spacing: 5){
                        
                        FootballPitch(viewModel: FootballPitchViewModel(homeTeamStartingXI: detailFixture.homeTeamLineupStartingXI, awayTeamStartingXI: detailFixture.awayTeamLineupStartingXI, screenWidth: UIScreen.main.bounds.width))
                        
//                        Text("home team lineup")
//                        ForEach(detailFixture.homeTeamLineup, id: \.id){lineup in
//                            Text("\(lineup.teamEnum) team \(lineup.teamName)")
//                            Text("coach \(lineup.coachName) image \(lineup.coachImage ?? "") ")
//                            Text("Formation \(lineup.formation)")
//                        }
//                        
//                        Text("home team starting team")
//                        
//                        ForEach(detailFixture.homeTeamLineupStartingXI, id: \.id){player in
//                            Text("\(player.name) \(player.position) number \(player.number) is substitute \(player.isSubstitute) grid \(player.grid ?? "")")
//                        }
                        
                        Text("home team substitutes")
                        ForEach(detailFixture.homeTeamLineupSubstitutes, id: \.id){player in
                            Text("\(player.name) \(player.position) number \(player.number) is substitute \(player.isSubstitute) grid \(player.grid ?? "")")
                        }
                        
//                        Text("awat team lineup")
//                        ForEach(detailFixture.awayTeamLineup, id: \.id){lineup in
//                            Text("\(lineup.teamEnum) team \(lineup.teamName)")
//                            Text("coach \(lineup.coachName) image \(lineup.coachImage ?? "") ")
//                            Text("Formation \(lineup.formation)")
//                        }
//                        
//                        Text("away team starting team")
//                        ForEach(detailFixture.awayTeamLineupStartingXI, id: \.id){player in
//                            Text("\(player.name) \(player.position) number \(player.number) is substitute \(player.isSubstitute) grid \(player.grid ?? "")")
//                        }
                        
                        Text("away team substitutes")
                        ForEach(detailFixture.awayTeamLineupSubstitutes, id: \.id){player in
                            Text("\(player.name) \(player.position) number \(player.number) is substitute \(player.isSubstitute) grid \(player.grid ?? "")")
                        }
                    }
                    
                    
    //              then comes the player stats for top players, like who scored the most, who assisted the most, etc. only the top players here. On clicking that section, should open up the player performance page. list of all the players, which should expand with the player stats. maybe another page for showing an individual player stats.
                    
                    VStack(spacing: 5){
                        Text("home team player stats")
                        ForEach(detailFixture.homeTeamPlayerStats, id: \.id){player in
                            Text("\(player.teamName) player \(player.playerName) \(player.number) minutes played \(player.minutes ?? 0) was substituted \(player.substitute)")
                        }
                        
                        Text("away team player stats")
                        ForEach(detailFixture.awayTeamPlayerStats, id: \.id){player in
                            Text("\(player.teamName) player \(player.playerName) \(player.number) minutes played \(player.minutes ?? 0) was substituted \(player.substitute)")
                        }
                    }
                    
                    
    //                overall match stats.
                    VStack(spacing: 5){
                        Text("overall Match Stats")
                        Text("home team stats")
                        ForEach(detailFixture.homeTeamStats, id: \.id){stat in
                            Text("\(stat.teamEnum) team  type \(stat.type) value \(stat.stringValue ?? "")")
                        }
                        
                        Text("away team stats")
                        ForEach(detailFixture.awayTeamStats, id: \.id){stat in
                            Text("\(stat.teamEnum) team  type \(stat.type) value \(stat.stringValue ?? "")")
                        }
                    }
    //                match events. Different layout for different events. like yellow card, goal, own goal, etc.
                    
                    VStack(spacing: 5){
                        ForEach(detailFixture.fixtureEvents, id: \.id){event in
                            Text(" on \(event.timeElapsed) extratime \(event.extraTime ?? 0) team \(event.teamName) player \(event.playerName) event type \(event.eventType) details \(event.details) comment \(event.comment ?? "")")
                        }
                    }
                    
    //                the sections with player stats, match stats, and match events, should be collapsable, to fit in one single page with minimum scrolling.
                    
                }else{
                    Text("fetching match data")
                }
            }
        }
        
        .onAppear {
            print("getting detail data")
            Task{
                await viewModel.getDetailFixture(fixtureID: Constants.getDetailFixtureTeamID())
            }
        }
    }
}
