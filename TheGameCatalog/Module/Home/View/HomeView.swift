//
//  HomeView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
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
                        GameListView(leftTitle: "Popular Game", listGame: presenter.games)
                        GameListView(leftTitle: "New Game", listGame: presenter.games)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Welcome, Dion!")
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        self.presenter.linkBuilderProfile {
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
            if presenter.games.isEmpty {
                presenter.getGames()
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
            ForEach(presenter.games, id: \.id) { game in
                self.presenter.linkBuilder(gameId: game.id) {
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
            self.presenter.linkBuilderListGame(title: leftTitle) {
                Text("See more")
                    .foregroundColor(Color("brandColor"))
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(listGame, id: \.id) { game in
                    self.presenter.linkBuilder(gameId: game.id) {
                        GameCard(game: game)
                    }.foregroundColor(.white)
                }
            }
        }
        .padding(.bottom, 10)
        .padding(.horizontal)

    }
}
