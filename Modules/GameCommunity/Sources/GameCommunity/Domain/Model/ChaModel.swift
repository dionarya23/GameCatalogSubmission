//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import Foundation
import FirebaseFirestore

public struct ChatModel: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    public var userId: String
    public var fullname: String
    public var message: String
    public var createdAt: Double
}

