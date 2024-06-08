//
//  RemoteDataSource.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import Combine
import Alamofire

protocol RemoteDataSourceProtocol: AnyObject {
    func getGameDetail(by id: Int) -> AnyPublisher<GameDetailResponse, Error>
    func getUpdatedGame() -> AnyPublisher<[GameListResult], Error>
    func getSearchGame(by title: String) -> AnyPublisher<[GameListResult], Error>
}

final class RemoteDataSource: NSObject {
    private override init() { }

    static let sharedIntance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func getGameDetail(by id: Int) -> AnyPublisher<GameDetailResponse, Error> {
        return Future<GameDetailResponse, Error> { completion in
            if let url = URL(string: Endpoints.Gets.detail.url + "\(id)") {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: GameDetailResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    func getUpdatedGame() -> AnyPublisher<[GameListResult], Error> {
        return Future<[GameListResult], Error> { completion in
            if let url = URL(string: Endpoints.Gets.gamesUpdated.url) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: GameListResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    func getSearchGame(by title: String) -> AnyPublisher<[GameListResult], Error> {
        return Future<[GameListResult], Error> { completion in
            if let url = URL(string: "\(Endpoints.Gets.search.url)\(title)") {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: GameListResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
