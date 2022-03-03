//
//  ComicsModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 03/03/22.
//

import SwiftUI


struct APIComicResult: Codable {
    let status: String
    let data: APIComicData
}

struct APIComicData: Codable {
    let count: Int
    let results: [Comic]
}

struct Comic: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String?
    let thumbnail: [String: String]
}
