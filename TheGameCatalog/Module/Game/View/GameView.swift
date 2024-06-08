//
//  GameView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var presenter: GamePresenter
    var title: String

    var body: some View {
        if presenter.isLoading {
            loadingIndicator
        } else if presenter.isError {
            errorIndicator
        } else {
            List {
                ForEach(presenter.listGame, id: \.id) { game in
                    self.presenter.linkBuilder(gameId: game.id) {
                        ListGameCell(game: game)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(title)
            .onAppear {
                if presenter.listGame.isEmpty {
                    presenter.getGames()
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
}
