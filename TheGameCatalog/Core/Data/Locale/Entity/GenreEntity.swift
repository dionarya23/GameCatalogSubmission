//
//  GenreEntity.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import RealmSwift

class GenreEntity: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    let games = LinkingObjects(fromType: GameEntity.self, property: "genres")

    override static func primaryKey() -> String? {
        return "id"
    }
}
