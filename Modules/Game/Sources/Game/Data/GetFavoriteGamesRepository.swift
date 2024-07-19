//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 08/07/24.
//

import Core
import Combine

public struct GetFavoriteGamesRepository<
    GameLocaleDataSource: LocaleDataSource,
    Transformer: Mapper
>: Repository where
GameLocaleDataSource.Request == String,
GameLocaleDataSource.Response == GameEntity,
Transformer.Request == String,
Transformer.Response == [GameListResult],
Transformer.Entity == [GameEntity],
Transformer.Domain == [GameModel]
{
    public typealias Request = String
    public typealias Response = [GameModel]
    
    private let localeDataSource: GameLocaleDataSource
    private let mapper: Transformer
    
    public init(
        localeDataSource: GameLocaleDataSource,
        mapper: Transformer
    ) {
        self.localeDataSource = localeDataSource
        self.mapper = mapper
    }
    
    public func execute(request: String?) -> AnyPublisher<[GameModel], Error> {
        return self.localeDataSource.list(request: request)
            .map { self.mapper.transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
    }
}
