//
//  GameModel.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation

struct GameModel: Equatable, Identifiable {
    let id: Int
    let name: String
    let backgroundImage: String
    var descriptionRaw: String
    var released: String?
    var rating: Double
    var genres: [GenreModel]
    var favorite: Bool
}
