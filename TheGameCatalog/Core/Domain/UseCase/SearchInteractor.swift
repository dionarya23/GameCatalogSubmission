//
//  SearchInteractor.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 08/06/24.
//
import Foundation
import Combine

protocol SearchUseCase {
    func getSearchGame(by title: String) -> AnyPublisher<[GameModel], Error>
}

class SearchInteractor: SearchUseCase {
    private let repository: GameRepositoryProtocol
    required init(
        repository: GameRepositoryProtocol
    ) {
        self.repository = repository
    }
    func getSearchGame(by title: String) -> AnyPublisher<[GameModel], any Error> {
        return self.repository.getSearchGame(by: title)
    }
}
