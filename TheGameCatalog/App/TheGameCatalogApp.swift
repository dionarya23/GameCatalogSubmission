//
//  TheGameCatalogApp.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Core
import Game
import GameCommunity

let injection = Injection()

let gameUseCase: Interactor<
    String,
    [GameModel],
    GetGamesRepository<
        GetGamesRemoteDataSource,
        GamesTransformer<GenreTransformer>
    >
> = injection.provideHome()

let getFavoriteUseCase: Interactor<
    String,
    [GameModel],
    GetFavoriteGamesRepository<
        GetFavoriteGamesLocaleDataSource,
        GamesTransformer<GenreTransformer>
    >
> = injection.provideFavorite()

let updateFavoriteUseCase: Interactor<
    String,
    GameModel,
    UpdateFavoriteGameRepository<
        GetGamesLocaleDataSource,
        GameTransformer<GenreTransformer>
    >
> = injection.provideUpdateFavorite()

let searchUseCase: Interactor<
    String,
    [GameModel],
    SearchGamesRepository<
        GetGamesRemoteDataSource,
        GamesTransformer<GenreTransformer>
    >
> = injection.provideSearch()

let loginUseCase: Interactor<
    RequestLogin,
    UserModel,
    LoginRepository<
        LoginRemoteDataSource
    >
> = injection.provideLogin()

let registerUseCase: Interactor<
    RequestRegister,
    UserModel,
    RegisterRepository<
        RegisterRemoteDataSource
    >
> = injection.provideRegister()

let getChatUseCase: Interactor<
    String,
    [ChatModel],
    GetChatsRepository<
        GetChatsRemoteDataSource
    >
> = injection.provideChats()

let getUserUseCase: Interactor<
    String,
    UserModel,
    GetUsersRepository<
        GetUsersRemoteDataSource
    >
> = injection.provideUser()

let sendChatUseCase: Interactor<
    ChatModel,
    Bool,
    SendChatRepository<
        SendChatRemoteDataSource
    >
> = injection.provideSendChat()

@main
struct TheGameCatalogApp: App {
    init() {
        FirebaseApp.configure()
    }

var body: some Scene {
    let homePresenter = GetListPresenter(useCase: gameUseCase)
    let favoritePresenter = GameFavoritePresenter(
        getFavoriteUseCase: getFavoriteUseCase,
        updateFavroriteUseCase: updateFavoriteUseCase
    )
    let searchPresenter = SearchPresenter(useCase: searchUseCase)
    let communityPresenter = GameCommunityPresenter(
        loginUseCase: loginUseCase,
        chatUseCase: getChatUseCase,
        registerUseCase: registerUseCase,
        userUseCase: getUserUseCase,
        sendChatUseCase: sendChatUseCase
    )

    WindowGroup {
        ContentView()
            .environmentObject(homePresenter)
            .environmentObject(favoritePresenter)
            .environmentObject(searchPresenter)
            .environmentObject(communityPresenter)
            .preferredColorScheme(.dark)
    }
    }
}
