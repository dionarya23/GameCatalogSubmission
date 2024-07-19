//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 08/07/24.
//

import Core
import Combine

public struct GetGamesRepository<
    GameRemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where
GameRemoteDataSource.Request == String,
GameRemoteDataSource.Response == [GameListResult],
Transformer.Request == String,
Transformer.Response == [GameListResult],
Transformer.Entity == [GameEntity],
Transformer.Domain == [GameModel]
{
    public typealias Request = String
    public typealias Response = [GameModel]
    
    private let remoteDataSource: GameRemoteDataSource
    private let mapper: Transformer

    public init(
     remoteDataSource: GameRemoteDataSource,
      mapper: Transformer
    ) {
      self.remoteDataSource = remoteDataSource
      self.mapper = mapper
    }
        
    public func execute(request: String?) -> AnyPublisher<[GameModel], Error> {
        return self.remoteDataSource.execute(request: request)
            .map { self.mapper.transformResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }

    
}
