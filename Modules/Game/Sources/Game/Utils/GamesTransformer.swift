//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import RealmSwift

public struct GamesTransformer<
  GenreMapper: Mapper
>: Mapper where
  GenreMapper.Request == String,
 GenreMapper.Response == [GenreResponse],
 GenreMapper.Entity == List<GenreEntity>,
 GenreMapper.Domain == [GenreModel]
{
  public typealias Request = String
  public typealias Response = [GameListResult]
  public typealias Entity = [GameEntity]
  public typealias Domain = [GameModel]

    private let genreMapper: GenreMapper

    public init(genreMapper: GenreMapper) {
      self.genreMapper = genreMapper
   }
    
    public func transformResponseToDomain(response: [GameListResult]) -> [GameModel] {
        var gameList: [GameModel] = []
        for result in response {
            let genres = self.genreMapper.transformResponseToDomain(response: result.genres)
            let game = GameModel(
                id: result.id,
                name: result.name,
                backgroundImage: result.backgroundImage,
                descriptionRaw: "",
                released: result.released,
                rating: result.rating ?? 0.0,
                genres: genres,
                favorite: false)
                        
            gameList.append(game)
        }
        
        return gameList
    }

  public func transformResponseToEntity(
    request: String?,
    response: [GameListResult]
  ) -> [GameEntity] {
      var gameList: [GameEntity] = [];
      for result in response {
          let game = GameEntity()
          let genres = self.genreMapper.transformResponseToEntity(request: request, response: result.genres)
       
          game.id = result.id
          game.name = result.name
          game.backgroundImage = result.backgroundImage
          game.rating = result.rating ?? 0.0
          game.released = result.released ?? "Uknown"
          game.favorite = false
          game.genres = genres
        
        gameList.append(game)
    }

      return gameList
  }

  public func transformEntityToDomain(
    entity: [GameEntity]
  ) -> [GameModel] {
      var games: [GameModel] = []
      for result in entity {
          let genres = self.genreMapper.transformEntityToDomain(entity: result.genres)
         let game = GameModel(
            id: result.id,
            name: result.name,
            backgroundImage: result.backgroundImage,
            descriptionRaw: result.descriptionRaw!,
            released: result.released,
            rating: result.rating,
            genres: genres,
            favorite: result.favorite
          )
          
          games.append(game)
    }
      
      return games
  }
}
