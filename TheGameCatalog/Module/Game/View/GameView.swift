//
//  GameView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//

import SwiftUI
import Core
import Game

struct GameView: View {
    @ObservedObject var presenter: GetListPresenter<String, GameModel, Interactor<
        String,
        [GameModel],
        GetGamesRepository<
            GetGamesRemoteDataSource,
            GamesTransformer<GenreTransformer>>
    >>
    var title: String

    var body: some View {
        if presenter.isLoading {
            loadingIndicator
        } else if presenter.isError {
            errorIndicator
        } else {
            List {
                ForEach(presenter.list, id: \.id) { game in
                    linkBuilder(for: game) {
                        ListGameCell(game: game)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(title)
            .onAppear {
                if presenter.list.isEmpty {
                    presenter.getList(request: nil)
                }
            }
        }
    }
}

extension GameView {
    var loadingIndicator: some View {
      VStack {
        Text("Loading...")
        ProgressView()
      }
    }
    var errorIndicator: some View {
      CustomEmptyView(
        image: "assetNotFound",
        title: presenter.errorMessage
      ).offset(y: 80)
    }
    func linkBuilder<Content: View>(
        for game: GameModel,
        @ViewBuilder content: () -> Content
      ) -> some View {

        NavigationLink(
            destination: HomeRouter().makeDetailView(gameId: game.id)
        ) { content() }
      }
}
