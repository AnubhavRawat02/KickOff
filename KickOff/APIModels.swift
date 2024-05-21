//
//  APIModels.swift
//  KickOff
//
//  Created by Anubhav Rawat on 11/05/24.
//

import Foundation
import SwiftUI


class League: Codable{
    var id: Int
    var name: String
    var type: String
    var leagueID: Int
    var country: String
    var logo: String?
    var flag: String?
    var countryCode: String?
}

class SuccessMessageResponse: Codable{
    var success: Bool
    var message: String?
}

class Fixtures: Codable{
    var fixtureID: Int
    var referee: String?
    var timeZone: String
    var date: String
    var venueName: String
    var city: String
    var leagueID: Int
    var homeTeamName: String
    var homeTeamLogo: String?
    var homeTeamWin: Bool?
    var awayTeamName: String
    var awayTeamLogo: String?
    var awayTeamWin: Bool?
    var homeTeamGoals: Int?
    var awayTeamGoals: Int?
    var homeTeamFirstHalf: Int?
    var homeTeamSecondHalf: Int?
    var homeTeamExtraTime: Int?
    var homeTeamPenalty: Int?
    var awayTeamFirstHalf: Int?
    var awayTeamSecondHalf: Int?
    var awayTeamExtraTime: Int?
    var awayTeamPenalty: Int?
}

class TodayFixture: Codable{
    var league: String
    var fixtures: [Fixtures]
}

// Following classes are only used for Detailed Fixtures

class DetailFixture: Codable{
    var detailedFixture: DetailFixtureData
    var fixtureEvents: [DetailFixtureEvent]
    var homeTeamLineup: [DetailFixtureLineup]
    var awayTeamLineup: [DetailFixtureLineup]
    var homeTeamLineupStartingXI: [DetailFixtureLineupPlayer]
    var homeTeamLineupSubstitutes: [DetailFixtureLineupPlayer]
    var awayTeamLineupStartingXI: [DetailFixtureLineupPlayer]
    var awayTeamLineupSubstitutes: [DetailFixtureLineupPlayer]
    var homeTeamStats: [DetailFixtureTeamStats]
    var awayTeamStats: [DetailFixtureTeamStats]
    var homeTeamPlayerStats: [DetailFixturePlayerStats]
    var awayTeamPlayerStats: [DetailFixturePlayerStats]
}

class DetailFixtureData: Codable{
    var id: Int
    var fixtureID: Int
    var referee: String
    var timeZone: String
    var date: String
    var venue: String
    var city: String
    var matchStatusLong: String
    var matchStatusShort: String
    var leagueName: String
    var leagueID: Int
    var leagueCountry: String
    var leagueLogo: String?
    var leagueFlag: String?
    var season: Int
    var round: String
    var homeTeamID: Int
    var homeTeamName: String
    var homeTeamLogo: String?
    var homeTeamWinner: Bool?
    var awayTeamID: Int
    var awayTeamName: String
    var awayTeamLogo: String?
    var awayTeamWinner: Bool?
    var homeGoals: Int?
    var awayGoals: Int?
    var homeTeamFirstHalf: Int?
    var homeTeamSecondHalf: Int?
    var homeTeamExtraTime: Int?
    var homeTeamPenalty: Int?
    var awayTeamFirstHalf: Int?
    var awayTeamSecondHalf: Int?
    var awayTeamExtraTime: Int?
    var awayTeamPenalty: Int?
}

class DetailFixtureEvent: Codable{
    var id: Int
    var fixtureID: Int
    var timeElapsed: Int
    var extraTime: Int?
    var teamID: Int
    var teamName: String
    var playerID: Int
    var playerName: String
    var assistID: Int?
    var assistName: String?
    var eventType: String
    var details: String
    var comment: String?
}



class DetailFixtureLineup: Codable{
    var id: Int
    var fixtureID: Int
    var teamEnum: String
    var teamID: Int
    var teamName: String
    var coachName: String
    var formation: String
    var coachImage: String?
}

class DetailFixtureLineupPlayer: Codable{
    var id: Int
    var playerID: Int
    var name: String
    var number: Int
    var position: String
    var teamID: Int
    var fixtureID: Int
    var isSubstitute: Bool
    var grid: String?
}

class DetailFixtureTeamStats: Codable{
    var id: Int
    var teamEnum: String
    var teamID: Int
    var fixtureID: Int
    var type: String
    var value: Int?
    var stringValue: String?
}

class DetailFixturePlayerStats: Codable{
    var id: Int
    var teamID: Int
    var teamName: String
    var fixtureID: Int
    var playerName: String
    var playerImage: String
    var minutes: Int?
    var number: Int
    var position: String
    var rating: String?
    var captain: Bool
    var substitute: Bool
    var offsides: Int?
    var totalShots: Int?
    var shotsOnTarget: Int?
    var totalGoals: Int?
    var goalsConceded: Int
    var assists: Int?
    var saves: Int?
    var totalPasses: Int?
    var keyPasses: Int?
    var passAccuracy: String?
    var totalTackles: Int?
    var blocks: Int?
    var interceptions: Int?
    var totalDuels: Int?
    var duelsWon: Int?
    var dribblesAttempted: Int?
    var successfulDribbles: Int?
    var pastDribbles: Int?
    var foulsDrawn: Int?
    var foulsComitted: Int?
    var yellowCards: Int
    var redCards: Int
    var penaltyWon: Int?
    var penaltyConceded: Int?
    var penaltyScored: Int
    var penaltyMissed: Int
    var penaltySaved: Int?
}
