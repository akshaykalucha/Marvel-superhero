//
//  MainModel.swift
//  SuperHero
//
//  Created by Akshay Kalucha on 28/02/22.
//

import Foundation
import SwiftUI


struct Welcome: Codable {
    let etag: String
    let data: DataClass
}

struct DataClass: Codable {
    let total: Int
//    let results: Result
}

//struct Result: Codable {
//    let id: Int
//    let name: String
//    let modified: Date
//    let thumbnail: Thumbnail
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case resultDescription = "description"
//        case modified, thumbnail
//    }
//}
//
//struct Thumbnail: Codable {
//    let path: String
//    let thumbnailExtension: String
//
//    enum CodingKeys: String, CodingKey {
//        case path
//        case thumbnailExtension = "extension"
//    }
//}
