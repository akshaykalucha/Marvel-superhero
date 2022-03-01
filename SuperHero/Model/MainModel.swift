//
//  MainModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 28/02/22.
//

import Foundation
import SwiftUI


struct Response: Codable {
    let etag: String
    let data: DataClass
}

struct DataClass: Codable {
    let total: Int
    let results: [Result]
}

struct Result: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let modified: String
    let thumbnail: Thumbnail
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case resultDescription = "description"
//        case modified, thumbnail
//    }
}
struct Thumbnail: Codable, Hashable {
    let path: String
    let ext: String
    
    private enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}
