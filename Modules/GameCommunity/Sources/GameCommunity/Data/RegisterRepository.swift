//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 13/07/24.
//

import Core
import Combine

public struct RegisterRepository<
    RegisterRemoteDataSource: DataSource
>: Repository where
RegisterRemoteDataSource.Request == RequestRegister,
RegisterRemoteDataSource.Response == UserModel
{
    public typealias Request = RequestRegister
    public typealias Response = UserModel

    private var remoteDataSource: RegisterRemoteDataSource
    public init(remoteDataSource: RegisterRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    public func execute(request: RequestRegister?) -> AnyPublisher<UserModel, Error> {
        return self.remoteDataSource.execute(request: request)
            .eraseToAnyPublisher()
    }
}
