//
//  Untitled.swift
//  textToImage
//
//  Created by Talha Gergin on 15.12.2024.
//

import Foundation
enum APIEndpoint{
    static let headers = [
        "x-rapidapi-key": "4bfe04b598msh82917e44902bbcap144ba5jsn733eab53fcb4",
        "x-rapidapi-host": "chatgpt-42.p.rapidapi.com",
        "Content-Type": "application/json"
    ]
    static let baseURL = "https://chatgpt-42.p.rapidapi.com/texttoimage3"
    /*
    case getLeaguesByCountry(Void)
    case getTeamsByLeagueID(Int)
    private var path:String{
        switch self{
        case .getLeaguesByCountry():
            return APIEndpoint.baseURL
        case .getTeamsByLeagueID(let leagueID):
            return "https://free-api-live-football-data.p.rapidapi.com/football-get-list-all-team?leagueid=\(leagueID)"
        }
    }
     */
}
