//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 13/07/24.
//

import Core
import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth

public struct RegisterRemoteDataSource: DataSource {
    public typealias Request = RequestRegister
    public typealias Response = UserModel
    private let db: Firestore
    private let authFirebase: Auth
    
    public init(firestore: Firestore, auth: Auth) {
        self.db = firestore
        self.authFirebase = auth
    }
    
    public func execute(request: RequestRegister?) -> AnyPublisher<UserModel, Error> {
        return Future<UserModel, Error> { completion in
            self.authFirebase.createUser(withEmail: (request?.email)!, password: (request?.password)!) { authResult, error in
                if let e = error {
                    completion(.failure(e))
                } else {
                    self.db.collection("users").addDocument(data: [
                        "userId": authResult?.user.uid ?? "",
                        "fullname": request?.fullName ?? "",
                        "email": request?.email ?? ""
                    ]) { error in
                        if let err = error {
                            completion(.failure(err))
                        } else {
                            let user = UserModel(
                                userId: authResult?.user.uid ?? "",
                                fullname: request!.fullName,
                                email: request!.email)
                            completion(.success(user))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()    }
}
