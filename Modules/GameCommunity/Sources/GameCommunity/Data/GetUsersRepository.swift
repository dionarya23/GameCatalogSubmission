//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import Core
import Combine

public struct GetUsersRepository<
    UsersRemoteDataSource: DataSource
>: Repository where
UsersRemoteDataSource.Request == String,
UsersRemoteDataSource.Response == UserModel
{
    public typealias Request = String
    public typealias Response = UserModel

    private var remoteDataSource: UsersRemoteDataSource
    public init(remoteDataSource: UsersRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    public func execute(request: String?) -> AnyPublisher<UserModel, Error> {
        return self.remoteDataSource.execute(request: request)
            .eraseToAnyPublisher()
    }
}
