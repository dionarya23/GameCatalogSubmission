//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import Combine
import RealmSwift
import Foundation

public struct GetFavoriteGamesLocaleDataSource : LocaleDataSource {
  public typealias Request = String
  public typealias Response = GameEntity
  private let realm: Realm

  public init(realm: Realm) {
    self.realm = realm
  }

  public func list(request: String?) -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { completion in

      let gameEntities = {
        realm.objects(GameEntity.self)
          .filter("favorite = \(true)")
      }()
      completion(.success(gameEntities.toArray(ofType: GameEntity.self)))

    }.eraseToAnyPublisher()
  }

  public func get(id: String) -> AnyPublisher<GameEntity, Error> {

    return Future<GameEntity, Error> { completion in
      if let gameEntity = {
        self.realm.objects(GameEntity.self).filter("id == %@", Int(id)!)
      }().first {
        do {
          try self.realm.write {
            gameEntity.setValue(!gameEntity.favorite, forKey: "favorite")
          }
          completion(.success(gameEntity))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }    
    public func add(entity: GameEntity) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }
    
    public func update(id: String) -> AnyPublisher<GameEntity, any Error> {
        fatalError()
    }

}
