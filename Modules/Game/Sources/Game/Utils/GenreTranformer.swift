//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 08/07/24.
//

import Core
import RealmSwift

public struct GenreTransformer: Mapper {

  public typealias Request = String
  public typealias Response = [GenreResponse]
  public typealias Entity = List<GenreEntity>
  public typealias Domain = [GenreModel]

  public init() { }
    
    public func transformResponseToEntity(request: String?, response: [GenreResponse]) -> List<GenreEntity> {
        let genreEntities = List<GenreEntity>()
        for genre in response {
            let genreEntity = GenreEntity()
            genreEntity.id = genre.id
            genreEntity.name = genre.name
            genreEntities.append(genreEntity)
        }
        
        return genreEntities
    }
    
    public func transformResponseToDomain(response: [GenreResponse]) -> [GenreModel] {
            var genresModel: [GenreModel] = []
            for genre in response {
                let genreModel = GenreModel(
                    id: Int(genre.id),
                    name: genre.name
                  )
                genresModel.append(genreModel)
            }
            
            return genresModel
    }

  public func transformEntityToDomain(entity: List<GenreEntity>) -> [GenreModel] {
    return entity.map { result in
      return GenreModel(
        id: result.id,
        name: result.name
      )
    }
  }

}
