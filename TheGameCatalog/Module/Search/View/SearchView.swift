//
//  SearchView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 08/06/24.
//

import SwiftUI
import Core
import Game

struct SearchView: View {
    @ObservedObject var presenter: SearchPresenter<
            GameModel,
            Interactor<
                String,
                [GameModel],
                SearchGamesRepository<
                    GetGamesRemoteDataSource,
                    GamesTransformer<GenreTransformer>
                >
            >
        >
    var body: some View {
        NavigationStack {
            List {
                ForEach(presenter.list, id: \.id) { game in
                    linkBuilder(for: game) {
                        ListGameCell(game: game)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search Game")
            .searchable(text: $presenter.keyword)
            .onChange(of: presenter.keyword) { _ in
                presenter.search()
            }
            .overlay(
                Group {
                    if presenter.isLoading {
                        loadingIndicator
                    } else if presenter.isError {
                        errorIndicator
                    }
                }
            )
        }
    }
}

extension SearchView {
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
      )
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
