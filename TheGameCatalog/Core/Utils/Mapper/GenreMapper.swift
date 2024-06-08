//
//  GenreMapper.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import RealmSwift

final class GenreMapper {
    static func mapGenreEntitiesToDomains(
      input genreEntities: [GenreEntity]
    ) -> [GenreModel] {
      return genreEntities.map { result in
        return GenreModel(
          id: Int(result.id),
          name: result.name
        )
      }
    }
    static func mapGenreResponseToDomains(
        input genres: [Genre]
    ) -> [GenreModel] {
        return genres.map { result in
          return GenreModel(
            id: Int(result.id),
            name: result.name
          )
        }
    }
    static func mapGenreResponseToEntities(
        input genres: [Genre]
    ) -> List<GenreEntity> {
        let genreEntities = List<GenreEntity>()
        for genre in genres {
            let genreEntity = GenreEntity()
            genreEntity.id = genre.id
            genreEntity.name = genre.name
            genreEntities.append(genreEntity)
        }
        return genreEntities
    }
}
