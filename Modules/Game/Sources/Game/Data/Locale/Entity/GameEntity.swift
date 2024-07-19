//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Foundation
import RealmSwift

public class GameEntity: Object {

  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var descriptionRaw: String? = ""
  @objc dynamic var backgroundImage = ""
  @objc dynamic var released = ""
  @objc dynamic var rating = 0.0
  @objc dynamic var favorite = false

  var genres = List<GenreEntity>()

  public override static func primaryKey() -> String? {
    return "id"
  }
}
