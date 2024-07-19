//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import Foundation
import Alamofire
import Combine

public struct GetGameRemoteDataSource: DataSource {
    public typealias Request = String
    public typealias Response = GameDetailResponse
    
    private let endpoint: String
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    public func execute(request: Request?) -> AnyPublisher<GameDetailResponse, Error> {
        return Future<GameDetailResponse, Error> { completion in
            guard let request = request else { return completion(.failure(URLError.invalidRequest))}
            
            if let url = URL(string: self.endpoint + request) {
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
}

