//
//  Injection.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation
import RealmSwift
import FirebaseFirestore
import FirebaseAuth
import Core
import Game
import GameCommunity

final class Injection: NSObject {
    private let realm = try? Realm()
    func provideDetail<U: UseCase>() -> U where U.Request == String, U.Response == GameModel {
        let locale = GetGamesLocaleDataSource(realm: realm!)
        let remote = GetGameRemoteDataSource(endpoint: Endpoints.Gets.detail.url)
        let genreMapper = GenreTransformer()
        let mapper = GameTransformer(genreMapper: genreMapper)
        let repository = GetGameRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper
        )
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideHome<U: UseCase>() -> U where U.Request == String, U.Response == [GameModel] {
        let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.games.url)
        let genreMapper = GenreTransformer()
        let mapper = GamesTransformer(genreMapper: genreMapper)
        let repository = GetGamesRepository(remoteDataSource: remote, mapper: mapper)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideSearch<U: UseCase>() -> U where U.Request == String, U.Response == [GameModel] {
        let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.search.url)
        let genreMapper = GenreTransformer()
        let gameMapper = GamesTransformer(genreMapper: genreMapper)
        let repository = SearchGamesRepository(
            remoteDataSource: remote, mapper: gameMapper
        )
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideFavorite<U: UseCase>() -> U where U.Request == String, U.Response == [GameModel] {
        let locale = GetFavoriteGamesLocaleDataSource(realm: realm!)
        let genreMapper = GenreTransformer()
        let mapper = GamesTransformer(genreMapper: genreMapper)
        let repository = GetFavoriteGamesRepository(localeDataSource: locale, mapper: mapper)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideUpdateFavorite<U: UseCase>() -> U where U.Request == String, U.Response == GameModel {
      let locale = GetGamesLocaleDataSource(realm: realm!)

      let genreMapper = GenreTransformer()
      let mapper = GameTransformer(genreMapper: genreMapper)

      let repository = UpdateFavoriteGameRepository(
        localeDataSource: locale,
        mapper: mapper)

        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideGameList<U: UseCase>() -> U where U.Request == String, U.Response == [GameModel] {
        let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.games.url)
        let genreMapper = GenreTransformer()
        let mapper = GamesTransformer(genreMapper: genreMapper)
        let repository = GetGamesRepository(remoteDataSource: remote, mapper: mapper)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideChats<U: UseCase>() -> U where U.Request == String, U.Response == [ChatModel] {
        let firestore = Firestore.firestore()
        let remote = GetChatsRemoteDataSource(firestore: firestore)
        let repository = GetChatsRepository(remoteDataSource: remote)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideUser<U: UseCase>() -> U where U.Request == String, U.Response == UserModel {
        let firestore = Firestore.firestore()
        let remote = GetUsersRemoteDataSource(firestore: firestore)
        let repository = GetUsersRepository(remoteDataSource: remote)
        if let interactor = Interactor(repository: repository) as? U {
           return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideLogin<U: UseCase>() -> U where U.Request == RequestLogin, U.Response == UserModel {
        let firestore = Firestore.firestore()
        let authFirebase = Auth.auth()
        let remote = LoginRemoteDataSource(firestore: firestore, auth: authFirebase)
        let repository = LoginRepository(remoteDataSource: remote)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideRegister<U: UseCase>() -> U where U.Request == RequestRegister, U.Response == UserModel {
        let firestore = Firestore.firestore()
        let authFirebase = Auth.auth()
        let remote = RegisterRemoteDataSource(firestore: firestore, auth: authFirebase)
        let repository = RegisterRepository(remoteDataSource: remote)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
    func provideSendChat<U: UseCase>() -> U where U.Request == ChatModel, U.Response == Bool {
        let firestore = Firestore.firestore()
        let remote = SendChatRemoteDataSource(firestore: firestore)
        let repository = SendChatRepository(remoteDataSource: remote)
        if let interactor = Interactor(repository: repository) as? U {
            return interactor
        } else {
            fatalError("Failed to cast Interactor to type \(U.self)")
        }
    }
}
