//
//  FavoriteInteractor.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import Foundation
import Combine

protocol FavoriteUseCase {
    func getFavoriteGame() -> AnyPublisher<[GameModel], Error>
    func getGenres() -> [GenreModel]
    func updatedFavoriteGame(by gameId: Int) -> AnyPublisher<GameModel, Error>
}

class FavoriteInteractor: FavoriteUseCase {
    private let repository: GameRepositoryProtocol
    required init(
        repository: GameRepositoryProtocol
    ) {
        self.repository = repository
    }
    func getFavoriteGame() -> AnyPublisher<[GameModel], any Error> {
        return self.repository.getFavoriteGames()
    }
    func updatedFavoriteGame(by gameId: Int) -> AnyPublisher<GameModel, Error> {
        return repository.updateFavoriteGame(by: gameId)
    }
    func getGenres() -> [GenreModel] {
        return [
            GenreModel(id: 4, name: "Action"),
            GenreModel(id: 51, name: "Indie"),
            GenreModel(id: 3, name: "Adventure"),
            GenreModel(id: 7, name: "Puzzle"),
            GenreModel(id: 2, name: "Shooter"),
            GenreModel(id: 5, name: "RPG")
        ]
    }
}
