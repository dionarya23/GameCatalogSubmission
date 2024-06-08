//
//  HomeRouter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 05/06/24.
//

import SwiftUI

class HomeRouter {
    func makeDetailView(gameId: Int) -> some View {
        let detailUseCase = Injection.init().provideDetail()
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        return DetailView(presenter: presenter, gameId: gameId)
    }
    func makeListGameView(title: String) -> some View {
        let gameListUseCase = Injection.init().provideGameList()
        let presenter = GamePresenter(gameUseCase: gameListUseCase)
        return GameView(presenter: presenter, title: title)
    }
    func makeProfileView() -> some View {
        let presenter = ProfilePresenter()
        return ProfileView(presenter: presenter)
    }
}
