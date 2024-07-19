//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 13/07/24.
//

import Core
import Combine

public struct SendChatRepository<
    SendChatRemoteDataSource: DataSource
>: Repository where
SendChatRemoteDataSource.Request == ChatModel,
SendChatRemoteDataSource.Response == Bool
{
    public typealias Request = ChatModel
    public typealias Response = Bool

    private var remoteDataSource: SendChatRemoteDataSource
    public init(remoteDataSource: SendChatRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    public func execute(request: ChatModel?) -> AnyPublisher<Bool, Error> {
        return self.remoteDataSource.execute(request: request)
            .eraseToAnyPublisher()
    }
}
