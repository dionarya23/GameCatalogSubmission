//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 11/07/24.
//

import Core
import Combine

public struct GetGameRepository<
    GameLocaleDataSource: LocaleDataSource,
    GameRemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where
GameLocaleDataSource.Request == String,
GameLocaleDataSource.Response == GameEntity,
GameRemoteDataSource.Request == String,
GameRemoteDataSource.Response == GameDetailResponse,
Transformer.Request == String,
Transformer.Response == GameDetailResponse,
Transformer.Entity == GameEntity,
Transformer.Domain == GameModel
{
    public typealias Request = String
    public typealias Response = GameModel
    
    private let localeDataSource: GameLocaleDataSource
    private let remoteDataSource: GameRemoteDataSource
    private let mapper: Transformer
    
    public init(
        localeDataSource: GameLocaleDataSource,
        remoteDataSource: GameRemoteDataSource,
        mapper: Transformer
    ) {
        self.localeDataSource = localeDataSource
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
    
    public func execute(request: String?) -> AnyPublisher<GameModel, Error> {
        guard let request = request else { fatalError("Request cannot be empty") }
        
        return self.localeDataSource.get(id: request)
          .flatMap { result -> AnyPublisher<GameModel, Error> in
              if result.id == 0  {
              return self.remoteDataSource.execute(request: request)
                .map { self.mapper.transformResponseToEntity(request: request, response: $0) }
                .catch { _ in self.localeDataSource.get(id: request) }
                .flatMap { self.localeDataSource.add(entity: $0) }
                .filter { $0 }
                .flatMap { _ in self.localeDataSource.get(id: request)
                    .map { self.mapper.transformEntityToDomain(entity: $0) }
                }.eraseToAnyPublisher()
            } else {
              return self.localeDataSource.get(id: request)
                .map { self.mapper.transformEntityToDomain(entity: $0) }
                .eraseToAnyPublisher()
            }
          }.eraseToAnyPublisher()
    }
}
