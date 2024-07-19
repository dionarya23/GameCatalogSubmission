//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Foundation

public struct GameModel: Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let backgroundImage: String
    public var descriptionRaw: String
    public var released: String?
    public var rating: Double
    public var genres: [GenreModel]
    public var favorite: Bool
}
