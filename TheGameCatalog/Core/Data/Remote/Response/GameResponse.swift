//
//  GameResponse.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation

struct GameListResponse: Decodable {
    let results: [GameListResult]
}

struct GameListResult: Decodable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String
    let rating: Double?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case genres
    }
}

struct GameDetailResponse: Decodable {
    let id: Int
    let name: String
    let descriptionRaw: String
    let backgroundImage: String
    let released: String?
    let rating: Double?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
        case rating
        case genres
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct MockData {
    static let sampleGame = GameListResult(
        id: 36901,
        name: "Resident evil 7 Banned Footage Vol.2",
        released: nil,
        backgroundImage: "https://media.rawg.io/media/screenshots/192/192174e67017878876bc8d49783a28be.jpg",
        rating: 0.0,
        genres: [Genre(id: 1, name: "Action")]
    )
    static let sampleGame2 = GameListResult(
        id: 37198,
        name: "Anstoss",
        released: "2024-10-11",
        backgroundImage: "https://media.rawg.io/media/screenshots/e2a/e2a1c70f6ce4864137461e0d2265ea23.jpg",
        rating: 1.0,
        genres: [Genre(id: 1, name: "Action")]
    )
    static let sampleGame3 = GameListResult(
        id: 3719,
        name: "Anstoss",
        released: "2024-10-11",
        backgroundImage: "https://media.rawg.io/media/screenshots/e2a/e2a1c70f6ce4864137461e0d2265ea23.jpg",
        rating: 1.0,
        genres: [Genre(id: 1, name: "Action")]
    )
    static let sampleGame4 = GameListResult(
        id: 37191,
        name: "Anstoss",
        released: "2024-10-11",
        backgroundImage: "https://media.rawg.io/media/screenshots/e2a/e2a1c70f6ce4864137461e0d2265ea23.jpg",
        rating: 1.0,
        genres: [Genre(id: 1, name: "Action")]
    )
    static let gamesUpdated = [sampleGame, sampleGame2, sampleGame3, sampleGame4]

    static let gameDetail = GameDetailResponse(
        id: 866837,
        name: "Ghost Catchers (kerneliron)",
        descriptionRaw: """
        This is my entry for the Mini Jam 117 Game Jam.
        It's an action ghost catching game where you must use your "Spectral"shotgun and ghost
        traps to stun and catch all the ghosts. The game features a short story, multiple rooms, and a boss fight.
        All game logic, graphics, and sound were created from scratch during the game jam period.
        """,
        backgroundImage: "https://media.rawg.io/media/screenshots/3ac/3ac81943d05c8410618355542f01c6ee.jpg",
        released: "2024-10-11",
        rating: 4.5,
        genres: [
            Genre(
                id: 13,
                name: "Atmospheric"
            ),
            Genre(
                id: 122,
                name: "Pixel Graphics"
            ),
            Genre(
                id: 663,
                name: "Ghosts"
            ),
            Genre(
                id: 620,
                name: "Spooky"
            ),
            Genre(
                id: 630,
                name: "Action"
            )

        ]
    )
}
