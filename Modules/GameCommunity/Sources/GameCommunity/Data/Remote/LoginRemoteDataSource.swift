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

public struct LoginRemoteDataSource: DataSource {
    public typealias Request = RequestLogin
    public typealias Response = UserModel
    private let db: Firestore
    private let authFirebase: Auth
    
    public init(firestore: Firestore, auth: Auth) {
        self.db = firestore
        self.authFirebase = auth
    }
    
    public func execute(request: RequestLogin?) -> AnyPublisher<UserModel, Error> {
        return Future<UserModel, Error> { completion in
            self.authFirebase.signIn(withEmail:( request?.email)!, password: (request?.password)!) { authResult, error in
                if let e = error {
                    completion(.failure(e))
                } else {
                    self.db.collection("users")
                        .whereField("userId", isEqualTo: [authResult?.user.uid])
                        .getDocuments { querySnapshot, error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                let userFirestore = querySnapshot?.documents.compactMap { document -> UserModel? in
                                    return try? document.data(as: UserModel.self)
                                } ?? []
                                let user = UserModel(
                                    userId: authResult?.user.uid ?? "",
                                    fullname: userFirestore.first?.fullname ?? "",
                                    email: (request?.email)!
                                )
                                completion(.success(user))
                            }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
