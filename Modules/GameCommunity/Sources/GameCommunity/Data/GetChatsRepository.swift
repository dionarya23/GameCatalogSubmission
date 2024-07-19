//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import Core
import Combine

public struct GetChatsRepository<
    ChatsRemoteDataSource: DataSource
>: Repository where
ChatsRemoteDataSource.Request == String,
ChatsRemoteDataSource.Response == [ChatModel]
{
    public typealias Request = String
    public typealias Response = [ChatModel]

    
    private var remoteDataSource: ChatsRemoteDataSource
    public init(
        remoteDataSource: ChatsRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    public func execute(request: String?) -> AnyPublisher<[ChatModel], Error> {
        return self.remoteDataSource.execute(request: request)
            .eraseToAnyPublisher()
    }
}
