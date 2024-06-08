//
//  GameRepository.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
   func getDetailGame(by gameId: Int) -> AnyPublisher<GameModel, Error>
   func updateFavoriteGame(by idMeal: Int) -> AnyPublisher<GameModel, Error>
   func getGames() -> AnyPublisher<[GameModel], Error>
   func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
   func getSearchGame(by title: String) -> AnyPublisher<[GameModel], Error>
}

final class GameRepository: NSObject {
    typealias GameInstance = (LocaleDataSource, RemoteDataSource) -> GameRepository
    fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocaleDataSource
    private init(locale: LocaleDataSource, remote: RemoteDataSource) {
        self.locale = locale
        self.remote = remote
    }
    static let sharedInstance: GameInstance = { localeRepo, remoteRepo in
        return GameRepository(locale: localeRepo, remote: remoteRepo)
    }
}

extension GameRepository: GameRepositoryProtocol {
    func getDetailGame(
        by gameId: Int
    ) -> AnyPublisher<GameModel, Error> {
      return self.locale.getGameDetail(by: gameId)
            .flatMap { result -> AnyPublisher<GameModel, Error> in
                if result.id == 0 {
                    return self.remote.getGameDetail(by: gameId)
                        .map { GameMapper.mapDetailGameResponseToEntity(by: gameId, input: $0) }
                        .catch { _ in self.locale.getGameDetail(by: gameId) }
                        .flatMap { self.locale.addGame(game: $0) }
                        .filter { $0 }
                        .flatMap { _ in
                            self.locale.getGameDetail(by: gameId)
                                .map { GameMapper.mapDetailGameEntityToDomain(input: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.locale.getGameDetail(by: gameId)
                        .map { GameMapper.mapDetailGameEntityToDomain(input: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    func updateFavoriteGame(by gameId: Int) -> AnyPublisher<GameModel, Error> {
        return self.locale.updateFavoriteGame(by: gameId)
          .map { GameMapper.mapDetailGameEntityToDomain(input: $0) }
          .eraseToAnyPublisher()
    }
    func getGames() -> AnyPublisher<[GameModel], Error> {
        return self.remote.getUpdatedGame()
            .map { GameMapper.mapGameResponseToDomain(input: $0) }
            .eraseToAnyPublisher()
    }
    func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
        return self.locale.getFavoriteGames()
            .map { GameMapper.mapGamesEntityToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
    func getSearchGame(by title: String) -> AnyPublisher<[GameModel], any Error> {
        return self.remote.getSearchGame(by: title)
            .map { GameMapper.mapGameResponseToDomain(input: $0) }
            .eraseToAnyPublisher()
    }
}
