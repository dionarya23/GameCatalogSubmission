//
//  SearchView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 08/06/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var presenter: SearchPresenter
    var body: some View {
        NavigationStack {
            if presenter.isError {
                errorIndicator
            } else {
                List {
                    ForEach(presenter.games, id: \.id) { game in
                        self.presenter.linkBuilder(gameId: game.id) {
                            ListGameCell(game: game)
                        }
                    }
                }
                .overlay(
                    Group {
                        if presenter.isLoading {
                            loadingIndicator
                        }
                    }
                )
                .listStyle(.plain)
                .navigationTitle("Search Game")
                .searchable(text: $presenter.searchText)
                .onChange(of: presenter.searchText) { searchText in
                    presenter.getSearchGame(by: searchText)
                }
            }
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
      ).offset(y: 80)
    }
}
