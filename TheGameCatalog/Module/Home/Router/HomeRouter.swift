//
//  HomeRouter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 05/06/24.
//

import SwiftUI
import Core
import Game

class HomeRouter {
    func makeListGameView(title: String) -> some View {
        let gameListUseCase: Interactor<
            String,
            [GameModel],
            GetGamesRepository<
                    GetGamesRemoteDataSource,
                    GamesTransformer<GenreTransformer>>
        > = Injection.init().provideGameList()
        let presenter: GetListPresenter<String, GameModel, Interactor<
            String,
            [GameModel],
            GetGamesRepository<
                GetGamesRemoteDataSource,
                GamesTransformer<GenreTransformer>>
        >> = GetListPresenter(useCase: gameListUseCase)
        return GameView(presenter: presenter, title: title)
    }
    func makeDetailView(gameId: Int) -> some View {
        let gameUseCase: Interactor<
          String,
          GameModel,
          GetGameRepository<
            GetGamesLocaleDataSource,
            GetGameRemoteDataSource,
            GameTransformer<GenreTransformer>>
        > = Injection.init().provideDetail()

        let favoriteUseCase: Interactor<
            String,
            GameModel,
            UpdateFavoriteGameRepository<
                GetGamesLocaleDataSource,
                GameTransformer<GenreTransformer>>
        > = Injection.init().provideUpdateFavorite()

        let presenter = GamePresenter(gameUseCase: gameUseCase, favoriteUseCase: favoriteUseCase)
        return DetailView(gameId: gameId, presenter: presenter)
    }
    func makeProfileView() -> some View {
        let presenter = ProfilePresenter()
        return ProfileView(presenter: presenter)
    }
}
