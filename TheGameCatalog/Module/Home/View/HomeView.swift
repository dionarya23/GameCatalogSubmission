//
//  HomeView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Core
import Game
import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: GetListPresenter<
            String,
            GameModel,
            Interactor<
                String,
                [GameModel],
                GetGamesRepository<
                    GetGamesRemoteDataSource,
                    GamesTransformer<GenreTransformer>
                >
            >
        >
    var body: some View {
        NavigationView {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorIndicator
            } else {
                ScrollView {
                    VStack {
                        customCorouselView
                        GameListView(leftTitle: "Popular Game", listGame: presenter.list)
                        GameListView(leftTitle: "New Game", listGame: presenter.list)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Welcome, Dion!")
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        linkBuilderProfile {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(Color("brandColor"))
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            if presenter.list.isEmpty {
                presenter.getList(request: "")
            }
        }
    }
}

extension HomeView {
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
    var customCorouselView: some View {
        TabView {
            ForEach(presenter.list, id: \.id) { game in
                linkBuilder(for: game) {
                    CarouselCard(gameUpdated: game)
                }
                .foregroundColor(.white)
            }
       }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
       .frame(height: 310)
    }
    @ViewBuilder
    func GameListView(leftTitle: String, listGame: [GameModel]) -> some View {
        HStack {
            Text(leftTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.title3)
            Spacer()
            linkBuilderListGame(title: leftTitle) {
                Text("See more")
                    .foregroundColor(Color("brandColor"))
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(listGame, id: \.id) { game in
                    linkBuilder(for: game) {
                        GameCard(game: game)
                    }.foregroundColor(.white)
                }
            }
        }
        .padding(.bottom, 10)
        .padding(.horizontal)

    }
    func linkBuilder<Content: View>(
        for game: GameModel,
        @ViewBuilder content: () -> Content
      ) -> some View {
        NavigationLink(destination: HomeRouter().makeDetailView(gameId: game.id)) { content() }
      }
    func linkBuilderProfile<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: HomeRouter().makeProfileView()) { content() }
    }
    func linkBuilderListGame<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: HomeRouter().makeListGameView(title: title)) { content() }
    }

}
