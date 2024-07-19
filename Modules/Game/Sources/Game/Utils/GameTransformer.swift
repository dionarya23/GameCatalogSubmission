//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import RealmSwift

public struct GameTransformer<
  GenreMapper: Mapper
>: Mapper where
 GenreMapper.Request == String,
 GenreMapper.Response == [GenreResponse],
 GenreMapper.Entity == List<GenreEntity>,
 GenreMapper.Domain == [GenreModel]
{

  public typealias Request = String
  public typealias Response = GameDetailResponse
  public typealias Entity = GameEntity
  public typealias Domain = GameModel

  private let genreMapper: GenreMapper

  public init(genreMapper: GenreMapper) {
    self.genreMapper = genreMapper
  }

  public func transformResponseToEntity(request: String?, response: GameDetailResponse) -> GameEntity {
      let genres = self.genreMapper.transformResponseToEntity(request: request, response: response.genres)

    let gameEntity = GameEntity()
      gameEntity.id = response.id

      gameEntity.name = response.name
      gameEntity.descriptionRaw = response.descriptionRaw
      gameEntity.backgroundImage = response.backgroundImage
      gameEntity.released = response.released ?? "Unknown"
      gameEntity.rating = response.rating ?? 0.0
      gameEntity.favorite = false      
      gameEntity.genres = genres

    return gameEntity
  }
            
    public func transformResponseToDomain(response: GameDetailResponse) -> GameModel {
        let genres = self.genreMapper.transformResponseToDomain(response: response.genres)
        
        return GameModel(
            id: response.id,
            name: response.name,
            backgroundImage: response.backgroundImage,
            descriptionRaw: response.descriptionRaw,
            rating: response.rating ?? 0.0,
            genres: genres,
            favorite: false)
    }

  public func transformEntityToDomain(entity: GameEntity) -> GameModel {
    let genres =  self.genreMapper.transformEntityToDomain(entity: entity.genres)

    return GameModel(
      id: entity.id,
      name: entity.name,
      backgroundImage: entity.backgroundImage,
      descriptionRaw: entity.descriptionRaw!,
      released: entity.released,
      rating: entity.rating,
      genres: genres,
      favorite: entity.favorite
    )
  }
}
