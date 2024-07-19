//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 12/07/24.
//

import Foundation
import FirebaseFirestore

public struct UserModel: Identifiable, Codable {
    @DocumentID public var id: String?
    public let userId: String
    public let fullname: String
    public let email: String
}


public struct RequestLogin {
    public let email: String
    public let password: String
}

public struct RequestRegister {
    public let email: String
    public let password: String
    public let fullName: String
}
