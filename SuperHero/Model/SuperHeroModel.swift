//
//  SuperHeroModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 04/03/22.
//

import Foundation
import SwiftUI


struct SPResponse: Codable {
    let resultsfr: String?
    let results: [SPResults]?
    let error: String?
    let response: String?
    
    enum CodingKeys: String, CodingKey {
        case resultsfr = "results-for"
        case results, error, response
    }
}


struct SPResults: Codable, Identifiable {
    let id: String
    let name: String
    let powerstats: powerStats
    let biography: biography
    let image: [String: String]
}

struct powerStats: Codable {
    let intelligence: String
    let strength: String
    let speed: String
    let durability: String
    let power: String
    let combat: String
}


struct biography: Codable {
    let fname: String
    let ego: String
    
    enum CodingKeys: String, CodingKey {
        case fname = "full-name"
        case ego = "alter-egos"
    }
}
