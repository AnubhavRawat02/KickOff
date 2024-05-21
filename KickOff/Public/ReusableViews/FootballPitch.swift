//
//  FootballPitch.swift
//  KickOff
//
//  Created by Anubhav Rawat on 19/05/24.
//

import Foundation
import SwiftUI

class FootballPitchViewModel: ObservableObject{
    
    class FootballLineup{
        
    }
    
    var screenWidth: CGFloat
    
    var pitchWidth: CGFloat
    var pitchHeight: CGFloat
    
    var hometeamGrid: [Int]
    var awayTeamGrid: [Int]
    
    var homeTeamDict: [Int: [Int: DetailFixtureLineupPlayer]]
    var awayTeamDict: [Int: [Int: DetailFixtureLineupPlayer]]
    
//    init(screenWidth: CGFloat){
    init(homeTeamStartingXI: [DetailFixtureLineupPlayer], awayTeamStartingXI: [DetailFixtureLineupPlayer], screenWidth: CGFloat){
//        let screenWidth = UIScreen.main.bounds.size.width
        
        print("this is screen width \(screenWidth)")
        self.screenWidth = screenWidth
        
        let aspectRatio: CGFloat = 1.56
        
        self.pitchWidth = screenWidth * 0.80
        self.pitchHeight = screenWidth * 0.80 * aspectRatio
        
        self.homeTeamDict = FootballPitchViewModel.getFormationFromStartingXI(startingXI: homeTeamStartingXI, reversed: false)
        
        self.awayTeamDict = FootballPitchViewModel.getFormationFromStartingXI(startingXI: awayTeamStartingXI, reversed: true)
        
        
        self.hometeamGrid = [4, 3, 3]
        self.awayTeamGrid = [3, 2, 4, 1]
    }
    
    static func getFormationFromStartingXI(startingXI: [DetailFixtureLineupPlayer], reversed: Bool) -> [Int: [Int: DetailFixtureLineupPlayer]]{
        var teamArray: [Int: [DetailFixtureLineupPlayer]] = [:]
        
        for teamPlayer in startingXI{
            let splitGrid = teamPlayer.grid!.split(separator: ":")
            let row = Int(splitGrid[0])!
            if var arr = teamArray[row]{
                arr.append(teamPlayer)
                teamArray[row] = arr
            }else{
                teamArray[row] = [teamPlayer]
            }
        }
        var finalTeamDict: [Int: [Int : DetailFixtureLineupPlayer]] = [:]
        
        for (row, players) in teamArray{
            var rowPlayers: [Int: DetailFixtureLineupPlayer] = [:]
            for player in players{
                let splitGrid = player.grid!.split(separator: ":")
                let position = Int(splitGrid[1])!
                rowPlayers[position] = player
            }
            finalTeamDict[row] = rowPlayers
        }
        
        print("#########before############")
        for (row, players) in finalTeamDict{
            for(position, player) in players{
                print("\(row):\(position) for \(player.name)")
            }
        }
        
        let sortedDict = reversed ? finalTeamDict.sorted(by: { $0.key > $1.key }) : finalTeamDict.sorted(by: { $0.key < $1.key })
        let sorted = Dictionary(uniqueKeysWithValues: sortedDict)
        
        print("#########after############")
        for (row, players) in sorted{
            for(position, player) in players{
                print("\(row):\(position) for \(player.name)")
            }
        }
        
        return sorted
    }
    
}

struct FootballPitch: View {
    
    @StateObject var viewModel: FootballPitchViewModel
    
    var body: some View {
        ZStack{
            Image("FootballPitch")
                .resizable()
                .scaledToFill()
                .frame(width: viewModel.pitchWidth, height: viewModel.pitchHeight)
            
            VStack{
//                home team lineup
                homeTeamLineup
                
//                away team lineup
                awayTeamLineup
            }
            .frame(width: viewModel.pitchWidth, height: viewModel.pitchHeight)
            
        }
        .frame(width: viewModel.pitchWidth, height: viewModel.pitchHeight)
        
    }
    
    @ViewBuilder
    var homeTeamLineup: some View{
        VStack{
            ForEach(1...viewModel.homeTeamDict.keys.count, id: \.self){ key in
                HStack{
                    ForEach(1...viewModel.homeTeamDict[key]!.keys.count, id: \.self){k in
                        PlayerImageOnPitch(
                            name: viewModel.homeTeamDict[key]?[k]?.name ?? "no name",
                            number: viewModel.homeTeamDict[key]?[k]?.number ?? 0,
                            numberOfGoals: 2,
                            wasSubstituted: false
                        )
                    }
                }
            }
        }.frame(width: viewModel.pitchWidth, height: viewModel.pitchHeight / 2)
    }
    
    @ViewBuilder
    var awayTeamLineup: some View{
        VStack{
            
                ForEach((1...viewModel.awayTeamDict.keys.count).reversed(), id: \.self){ key in
                    HStack{
                        ForEach(1...viewModel.awayTeamDict[key]!.keys.count, id: \.self){k in
                            PlayerImageOnPitch(
                                name: viewModel.awayTeamDict[key]?[k]?.name ?? "no name",
                                number: viewModel.awayTeamDict[key]?[k]?.number ?? 0,
                                numberOfGoals: 2,
                                wasSubstituted: false
                            )
                        }
                    }
                }
            
        }.frame(width: viewModel.pitchWidth, height: viewModel.pitchHeight / 2)
//            .rotationEffect(.degrees(180))
    }
}

struct PlayerImageOnPitch: View {
    
    var name: String
    var number: Int
    var numberOfGoals: Int
    var wasSubstituted: Bool
    
    var body: some View {
        VStack(spacing: 3){
            ZStack{
                Circle().fill(.orange).frame(width: 40)
                Text("\(number)")
                    .font(.system(size: 20, weight: .bold))
                if numberOfGoals != 0{
                    ZStack{
                        Image("FootballImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        if numberOfGoals > 1{
                            Text("\(numberOfGoals)")
                                .font(.system(size: 10))
                                .background(.white)
                                .offset(x: 4, y: 4)
                        }
                    }
                    .offset(x: 13, y: 14)
                    
                }
                
                if wasSubstituted{
                    Image(systemName: "arrowshape.down.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(.green)
                        .offset(x: -12, y: 17)
                }
            }
            Text("\(name)")
                .font(.system(size: 10, weight: .bold))
        }
    }
}



#Preview {
    PlayerImageOnPitch(name: "anubhav rawat", number: 7, numberOfGoals: 5, wasSubstituted: true)
//    FootballPitch(viewModel: FootballPitchViewModel(homeTeamFormations: "4-3-3", awayTeamFormations: "3-2-4-1"))
}
//430 screen width
