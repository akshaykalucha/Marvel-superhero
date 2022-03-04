//
//  SuperHeroModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 04/03/22.
//

import Foundation
import SwiftUI


struct SPResponse: Codable {
    let resultsfr: String
    
    private enum CodingKeys: String, CodingKey {
        case resultsfr = "results-for"
    }
}
