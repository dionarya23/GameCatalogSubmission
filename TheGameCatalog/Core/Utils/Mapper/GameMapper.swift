//
//  GameMapper.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation

final class GameMapper {
    static func mapDetailGameResponseToEntity(
      by gameId: Int,
      input gameResponse: GameDetailResponse
    ) -> GameEntity {
      let genres = GenreMapper.mapGenreResponseToEntities(
        input: gameResponse.genres
      )
      let gameEntity = GameEntity()
        gameEntity.id = gameResponse.id
        gameEntity.name = gameResponse.name
        gameEntity.descriptionRaw = gameResponse.descriptionRaw
        gameEntity.backgroundImage = gameResponse.backgroundImage
        gameEntity.released = gameResponse.released ?? "Unknow"
        gameEntity.rating = gameResponse.rating ?? 0.0
        gameEntity.genres = genres
      return gameEntity
    }
    static func mapDetailGameEntityToDomain(
        input gameEntity: GameEntity
    ) -> GameModel {
        let gameId = Int(gameEntity.id)
        let genres = GenreMapper.mapGenreEntitiesToDomains(
          input: Array(gameEntity.genres)
        )

        return GameModel(
            id: gameId,
            name: gameEntity.name,
            backgroundImage: gameEntity.backgroundImage,
            descriptionRaw: gameEntity.descriptionRaw ?? "",
            released: gameEntity.released,
            rating: gameEntity.rating,
            genres: genres,
            favorite: gameEntity.favorite
        )
    }
    static func mapGameResponseToDomain(input gameListResponse: [GameListResult]) -> [GameModel] {
        return gameListResponse.map { result in
            let genres = GenreMapper.mapGenreResponseToDomains(
                input: result.genres
            )
            return GameModel(
                id: result.id,
                name: result.name,
                backgroundImage: result.backgroundImage,
                descriptionRaw: "",
                released: result.released,
                rating: result.rating ?? 0.0,
                genres: genres,
                favorite: false
            )
        }
    }
    static func mapGamesEntityToDomains(
        input games: [GameEntity]
    ) -> [GameModel] {
        return games.map { game in
            let genres = GenreMapper.mapGenreEntitiesToDomains(
                input: Array(game.genres)
            )
                return GameModel(
                    id: game.id,
                    name: game.name,
                    backgroundImage: game.backgroundImage,
                    descriptionRaw: "",
                    released: game.released,
                    rating: game.rating,
                    genres: genres,
                    favorite: game.favorite
                )
        }
    }
}
