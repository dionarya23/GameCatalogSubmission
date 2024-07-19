//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 13/07/24.
//

import Core
import Combine

public struct LoginRepository<
    LoginRemoteDataSource: DataSource
>: Repository where
LoginRemoteDataSource.Request == RequestLogin,
LoginRemoteDataSource.Response == UserModel
{
    public typealias Request = RequestLogin
    public typealias Response = UserModel

    private var remoteDataSource: LoginRemoteDataSource
    public init(remoteDataSource: LoginRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    public func execute(request: RequestLogin?) -> AnyPublisher<UserModel, Error> {
        return self.remoteDataSource.execute(request: request)
            .eraseToAnyPublisher()
    }
}
