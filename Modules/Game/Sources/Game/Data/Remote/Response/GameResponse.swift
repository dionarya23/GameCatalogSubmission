//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Foundation

public struct GameListResponse: Decodable {
    let results: [GameListResult]
}

public struct GameListResult: Decodable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String
    let rating: Double?
    let genres: [GenreResponse]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case genres
    }
}

public struct GameDetailResponse: Decodable {
    let id: Int
    let name: String
    let descriptionRaw: String
    let backgroundImage: String
    let released: String?
    let rating: Double?
    let genres: [GenreResponse]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
        case rating
        case genres
    }
}

public struct GenreResponse: Decodable {
    let id: Int
    let name: String
}
