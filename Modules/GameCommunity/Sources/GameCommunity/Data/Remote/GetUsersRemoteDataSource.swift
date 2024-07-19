//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import Core
import Combine
import Foundation
import FirebaseFirestore

public struct GetUsersRemoteDataSource: DataSource {
    public typealias Request = String
    public typealias Response = UserModel
    private let db: Firestore
    
    public init(firestore: Firestore) {
        self.db = firestore
    }
    
    public func execute(request: Request?) -> AnyPublisher<UserModel, Error> {
           return Future<UserModel, Error> { completion in
               self.db.collection("users")
                   .whereField("userId", isEqualTo: request ?? "")
                   .getDocuments { querySnapshot, error in
                       if let error = error {
                           completion(.failure(error))
                       } else {
                           let userFirestore = querySnapshot?.documents.compactMap { document -> UserModel? in
                               return try? document.data(as: UserModel.self)
                           } ?? []
                           if let firstUser = userFirestore.first {
                               completion(.success(firstUser))
                           } else {
                               completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                           }
                       }
                   }
           }.eraseToAnyPublisher()
    }
}
