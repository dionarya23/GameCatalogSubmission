//
//  DetailInteractor.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import Combine

protocol DetailUseCase {
    func getDetailGame(by gameId: Int) -> AnyPublisher<GameModel, Error>
    func updateFavoriteGame(by gameId: Int) -> AnyPublisher<GameModel, Error>
}

class DetailInteractor: DetailUseCase {
    private let repository: GameRepositoryProtocol
    required init(
        repository: GameRepositoryProtocol
    ) {
        self.repository = repository
    }
    func getDetailGame(by gameId: Int) -> AnyPublisher<GameModel, Error> {
        return repository.getDetailGame(by: gameId)
    }
    func updateFavoriteGame(by gameId: Int) -> AnyPublisher<GameModel, Error> {
        return repository.updateFavoriteGame(by: gameId)
    }
}
