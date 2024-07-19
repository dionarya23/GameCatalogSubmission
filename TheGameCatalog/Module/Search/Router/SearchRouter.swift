//
//  SearchRouter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 08/06/24.
//

import SwiftUI
import Game
import Core

class SearchRouter {
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
}
