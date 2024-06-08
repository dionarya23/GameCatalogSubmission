//
//  GameListInteractor.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//

import Foundation
import Combine

protocol GameListUseCase {
    func getAllGame() -> AnyPublisher<[GameModel], Error>
}

class GameListInteractor: GameListUseCase {
    private let repository: GameRepositoryProtocol
    required init(
        repository: GameRepositoryProtocol
    ) {
        self.repository = repository
    }

    func getAllGame() -> AnyPublisher<[GameModel], any Error> {
        return self.repository.getGames()
    }
}
