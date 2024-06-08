//
//  LocaleDataSource.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import RealmSwift
import Combine

protocol LocaleDataSourceProtocol: AnyObject {
    func getGameDetail(by gameId: Int) -> AnyPublisher<GameEntity, Error>
    func updateGame(by gameId: Int, game: GameEntity) -> AnyPublisher<Bool, Error>
    func updateFavoriteGame(by gameId: Int) -> AnyPublisher<GameEntity, Error>
    func addGame(game: GameEntity) -> AnyPublisher<Bool, Error>
    func getFavoriteGames() -> AnyPublisher<[GameEntity], Error>
}

final class LocaleDataSource: NSObject {

  private let realm: Realm?

  private init(realm: Realm?) {
    self.realm = realm
  }

  static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
    return LocaleDataSource(realm: realmDatabase)
  }

}

extension LocaleDataSource: LocaleDataSourceProtocol {
    func getGameDetail(
      by gameId: Int
    ) -> AnyPublisher<GameEntity, Error> {
      return Future<GameEntity, Error> { completion in
        if let realm = self.realm {
          let meals: Results<GameEntity> = {
            realm.objects(GameEntity.self)
              .filter("id = %@", gameId)
          }()
            completion(.success(meals.first ?? GameEntity()))
        } else {
          completion(.failure(DatabaseError.invalidInstance))
        }
      }.eraseToAnyPublisher()
    }
    func updateGame(by gameId: Int, game: GameEntity) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { completion in
          if let realm = self.realm, let mealEntity = {
            realm.objects(GameEntity.self).filter("id = %@", gameId)
          }().first {
            do {
              try realm.write {
                mealEntity.setValue(game.name, forKey: "name")
                mealEntity.setValue(game.descriptionRaw, forKey: "descriptionRaw")
                mealEntity.setValue(game.backgroundImage, forKey: "backgroundImage")
                mealEntity.setValue(game.released, forKey: "released")
                mealEntity.setValue(game.rating, forKey: "rating")
                mealEntity.setValue(game.favorite, forKey: "favorite")
                mealEntity.setValue(game.genres, forKey: "genres")
              }
              completion(.success(true))
            } catch {
              completion(.failure(DatabaseError.requestFailed))
            }
          } else {
            completion(.failure(DatabaseError.invalidInstance))
          }
        }.eraseToAnyPublisher()
    }
    func updateFavoriteGame(
      by gameId: Int
    ) -> AnyPublisher<GameEntity, Error> {
      return Future<GameEntity, Error> { completion in
        if let realm = self.realm, let gameEntity = {
          realm.objects(GameEntity.self).filter("id = %@", gameId)
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
    func addGame(game: GameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(game, update: .all)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    func getFavoriteGames() -> AnyPublisher<[GameEntity], Error> {
      return Future<[GameEntity], Error> { completion in
        if let realm = self.realm {
          let favoriteGames: Results<GameEntity> = realm.objects(GameEntity.self).filter("favorite == true")
          let favoriteGamesArray = Array(favoriteGames)
          completion(.success(favoriteGamesArray))
        } else {
          completion(.failure(DatabaseError.invalidInstance))
        }
      }.eraseToAnyPublisher()
    }
}

extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
}
