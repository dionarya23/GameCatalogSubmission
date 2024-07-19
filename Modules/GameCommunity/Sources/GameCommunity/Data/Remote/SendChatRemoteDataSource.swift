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

public struct SendChatRemoteDataSource: DataSource {
    public typealias Request = ChatModel
    public typealias Response = Bool
    private let db: Firestore
    
    public init(firestore: Firestore) {
        self.db = firestore
    }
    
    public func execute(request: ChatModel?) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            self.db.collection("chats").addDocument(data: [
                "userId": request?.userId ?? "",
                "fullname": request?.fullname ?? "",
                "message": request?.message ?? "",
                "createdAt": request?.createdAt ?? ""
            ]) { error in
                if let err = error {
                    completion(.failure(err))
                } else {
                    completion(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
}
