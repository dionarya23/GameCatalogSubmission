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

public struct GetChatsRemoteDataSource: DataSource {
    public typealias Request = String
    public typealias Response = [ChatModel]
    private let db: Firestore
    
    public init(firestore: Firestore) {
        self.db = firestore
    }
    
    public func execute(request: Request?) -> AnyPublisher<[ChatModel], Error> {
        let subject = PassthroughSubject<[ChatModel], Error>()
        db.collection("chats")
            .order(by: "createdAt")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    subject.send(completion: .failure(error))
                } else {
                    let chats = querySnapshot?.documents.compactMap { document -> ChatModel? in
                        return try? document.data(as: ChatModel.self)
                    } ?? []
                    subject.send(chats)
                }
            }
        return subject.eraseToAnyPublisher()
    }
}
