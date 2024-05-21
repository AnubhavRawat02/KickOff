//
//  Constants.swift
//  KickOff
//
//  Created by Anubhav Rawat on 11/05/24.
//

import Foundation

class Constants{
    static let baseURL = "https://d640-2405-201-681b-89a-4945-1783-6cd3-b50d.ngrok-free.app"
    
    static func getAllLeaguesURL() -> String{
        return "\(baseURL)/adminapi/allLeagues"
    }
    
    static func setSelectedLeaguesURL() -> String{
        return "\(baseURL)/adminapi/setSelectedLeagues"
    }
    
    static func getSelectedLeaguesURL() -> String{
        return "\(baseURL)/adminapi/allSelectedLeagues"
    }
    
    static func getFixturesByLeagueID() -> String{
        return "\(baseURL)/publicApi/getFixturesUsingLeagueID"
    }
    static func getDetailFixtureByID() -> String{
        return "\(baseURL)/publicApi/getDetailFixtureUsingID"
//    https://a0b5-2405-201-681b-89a-b16b-cb56-a57e-f738.ngrok-free.app/publicApi/getDetailFixtureUsingID?fixtureID=1037953
    }
    
    static func getDetailFixtureTeamID() -> Int{
        return 1037953
    }
    
    static func getTodayFixtures() -> String{
        return "\(baseURL)/publicApi/getTodayFixture"
    }
}
