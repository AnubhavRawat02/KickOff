//
//  AllLeaguesView.swift
//  KickOff
//
//  Created by Anubhav Rawat on 11/05/24.
//

import Foundation
import SwiftUI

class AllLeaguesViewModel: ObservableObject{
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var tabTwoErrorMessage: String = ""
    
    @Published var allLeagues: [League] = []
    @Published var selectedLeagues: [League] = []
    
    @Published var tabTwoSelectedLeagues: [League] = []

    func getAllLeagues() async {
        do{
            let leagues = try await URLSession.shared.asyncRequest(
                urlString: Constants.getAllLeaguesURL(),
                encodingObj: [League].self,
                httpMethod: "GET",
                headers: nil,
                body: nil,
                queryParams: nil
            )
            
            DispatchQueue.main.async{
                self.allLeagues = leagues
            }
        }catch{
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
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
                self.tabTwoSelectedLeagues = selectedLeagues
            }
        }catch{
            DispatchQueue.main.async{
                self.tabTwoErrorMessage = error.localizedDescription
            }
        }
    }
    
    func sendSelectedLeagues() async{
        
        
        do{
            var leagueIDs = ""
            for le in selectedLeagues{
                leagueIDs = "\(leagueIDs), \(le.leagueID)"
            }
            print("all league ids \(leagueIDs)")
            let response = try await URLSession.shared.asyncRequest(
                urlString: Constants.setSelectedLeaguesURL(),
                encodingObj: SuccessMessageResponse.self,
                httpMethod: "POST",
                headers: nil,
                body: ["allLeagueIDs": leagueIDs],
                queryParams: nil
            )
            
            if response.success{
                DispatchQueue.main.async{
                    self.successMessage = response.message ?? "selected leagues set"
                }
            }else{
                DispatchQueue.main.async{
//                    self.errorMessage = response.message ?? "error while setting the selected leagues."
                }
            }
        }catch{
            DispatchQueue.main.async{
//                self.errorMessage = error.localizedDescription
            }
        }
    }
    
}

struct AllLeaguesView: View {
    
    @StateObject var viewModel = AllLeaguesViewModel()
    
    var body: some View {
        TabView {
            
            tabOneAllLeagues
                .tabItem {
                    Text("tab one")
                }
            
            tabTwoSelectedLeagues
                .tabItem {
                    Text("tab two")
                }
            
        }
    }
    
//    tab two
    @ViewBuilder
    var tabTwoSelectedLeagues: some View{
        VStack{
            if !viewModel.tabTwoErrorMessage.isEmpty{
                Text(viewModel.tabTwoErrorMessage)
            }else if !viewModel.tabTwoSelectedLeagues.isEmpty{
                ScrollView{
                    VStack(spacing: 10){
                        ForEach(viewModel.tabTwoSelectedLeagues, id: \.leagueID){league in
                            VStack(spacing: 2){
                                Text("\(league.name) from \(league.country)")
                            }
                        }
                    }
                }
            }else{
                Text("fetching selected leagues")
            }
        }.onAppear {
            Task{
                await viewModel.getAllSelectedLeagues()
            }
        }
        .refreshable {
            Task{
                await viewModel.getAllSelectedLeagues()
            }
        }
    }
    
//    tab one
    @ViewBuilder
    var tabOneAllLeagues: some View{
        VStack{
            if !viewModel.errorMessage.isEmpty{
                Text(viewModel.errorMessage)
            }else if !viewModel.allLeagues.isEmpty{
                VStack{
                    
                    Button {
                        Task{
                            await viewModel.sendSelectedLeagues()
                        }
                    } label: {
                        ZStack{
                            Capsule().fill(.orange).frame(width: 200, height: 20)
                            Text("Select Leagues")
                        }
                    }

                    
                    selectedLeaguesScrollView
                    
                    allLeaguesScrollView
                }
            }else{
                Text("fetching leagues")
            }
        }
        .onAppear {
            Task{
                await viewModel.getAllLeagues()
            }
        }
    }
    
    @ViewBuilder
    var selectedLeaguesScrollView: some View{
        ScrollView(.horizontal) {
            if viewModel.selectedLeagues.isEmpty{
                Text("no leagues selected")
            }else{
                HStack{
                    ForEach(viewModel.selectedLeagues, id: \.leagueID){league in
                        Text(league.name)
                            .onTapGesture {
                                viewModel.selectedLeagues.removeAll { l in
                                    l.name == league.name
                                }
                            }
                    }
                }
            }
        }
        .frame(height: 30)
    }
    
    @ViewBuilder
    var allLeaguesScrollView: some View{
        ScrollView{
            ForEach(viewModel.allLeagues, id: \.leagueID){league in
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(.orange.opacity(0.4)).frame(height: 60)
                    VStack{
                        Text("name: \(league.name)")
                        Text("country: \(league.country)")
                    }
                }
                .onTapGesture {
                    if !viewModel.selectedLeagues.contains(where: { l in
                        l.leagueID == league.leagueID
                    }){
                        viewModel.selectedLeagues.append(league)
                    }
                }
            }
        }
    }
}
