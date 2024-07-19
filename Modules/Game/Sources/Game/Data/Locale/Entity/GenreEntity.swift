//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Foundation
import RealmSwift

public class GenreEntity: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    let games = LinkingObjects(fromType: GameEntity.self, property: "genres")

    public override static func primaryKey() -> String? {
        return "id"
    }
}
