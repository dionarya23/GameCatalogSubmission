//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 08/07/24.
//

import Core
import Combine

public struct SearchGamesRepository<
  RemoteDataSource: DataSource,
  Transformer: Mapper
>: Repository where
  RemoteDataSource.Request == String,
  RemoteDataSource.Response == [GameListResult],
  Transformer.Response == [GameListResult],
  Transformer.Domain == [GameModel]
{

  public typealias Request = String
  public typealias Response = [GameModel]

  private let remoteDataSource: RemoteDataSource
  private let mapper: Transformer

  public init(
    remoteDataSource: RemoteDataSource,
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
