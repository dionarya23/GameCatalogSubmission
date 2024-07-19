//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import Foundation
import Combine
import RealmSwift


public struct GetGamesLocaleDataSource: LocaleDataSource {
    public typealias Request = String
    public typealias Response = GameEntity
    
    private let realm: Realm

    public init(realm: Realm) {
      self.realm = realm
    }

    public func get(id: String) -> AnyPublisher<GameEntity, Error> {
      return Future<GameEntity, Error> { completion in
        let games: Results<GameEntity> = {
          self.realm.objects(GameEntity.self)
            .filter("id == %@", Int(id)!)
        }()
        completion(.success(games.first ?? GameEntity()))
      }.eraseToAnyPublisher()
    }
    
    public func add(entity: GameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try self.realm.write {
                    self.realm.add(entity, update: .all)
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }
    
    public func list(request: String?) -> AnyPublisher<[GameEntity], Error> {
        fatalError()
    }
    public func update(id: String) -> AnyPublisher<GameEntity, Error> {
        return Future<GameEntity, Error> { completion in
          if let gameEntity = {
              self.realm.objects(GameEntity.self).filter("id = %@", Int(id)!)
          }().first {
            do {
              try realm.write {
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
}
