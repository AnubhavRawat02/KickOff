//
//  HomeView.swift
//  KickOff
//
//  Created by Anubhav Rawat on 12/05/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject{
    @Published var selectedLeagues: [League] = []
    @Published var selectedLeaguesError: String = ""
    
    func getAllSelectedLeagues() async {
        do{
            let selectedLeagues = try await URLSession.shared.asyncRequest(
                urlString: Constants.getSelectedLeaguesURL(),
                encodingObj: [League].self,
                httpMethod: "GET",
                headers: nil,
                body: nil,
                queryParams: nil
            )
            DispatchQueue.main.async{
                self.selectedLeagues = selectedLeagues
            }
        }catch{
            DispatchQueue.main.async{
                self.selectedLeaguesError = error.localizedDescription
            }
        }
    }
    
}

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    leaguesScrollView
                }
            }
            .onAppear {
                Task{
                    await viewModel.getAllSelectedLeagues()
                }
            }
        }
        
    }
    
    @ViewBuilder
    var leaguesScrollView: some View{
        if !viewModel.selectedLeagues.isEmpty{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(viewModel.selectedLeagues, id: \.leagueID){league in
                        NavigationLink {
                            LeagueOverview(viewModel: LeagueOverviewViewModel(league: league))
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10).fill(.orange.opacity(0.3)).frame(height: 100)
                                VStack{
                                    Text("\(league.name)  country: \(league.country)")
                                }
                                .padding(.horizontal, 20)
                            }
                        }

                    }
                }
            }
        }else{
            Text("Fetching Leagues")
        }
    }
}



