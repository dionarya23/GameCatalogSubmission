//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import Foundation
import Combine
import Alamofire

public struct GetGamesRemoteDataSource: DataSource {
    public typealias Request = String
    public typealias Response = [GameListResult]
    
    private let endpoint: String
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    public func execute(request: Request?) -> AnyPublisher<[GameListResult], any Error> {
        return Future<[GameListResult], Error> { completion in
            guard let request = request else { return completion(.failure(URLError.invalidRequest))}
            if let url = URL(string: self.endpoint + request) {
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
