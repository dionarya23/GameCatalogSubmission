//
//  FavoriteView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject var presenter: FavoritePresenter
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        NavigationView {
            VStack {
                if self.presenter.isLoading {
                    loadingIndicator
                } else if self.presenter.games.isEmpty {
                    emptyIndicator
                } else if self.presenter.isError {
                    errorIndicator
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(presenter.genres, id: \.id) { genre in
                                TagComponent(title: genre.name, isSelected: presenter.selectedGenreId == genre.id)
                                .onTapGesture {
                                    presenter.filterByGenre(genreId: genre.id)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    favoriteGameList.frame(maxWidth: .infinity)
                }
            }.navigationTitle("Favorite")
             .onAppear {
                presenter.getGamesAndGenres()
            }
             .alert(item: $presenter.alertItem) { alertItem in
                 Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
             }
        }
    }
}

extension FavoriteView {
    var loadingIndicator: some View {
      VStack {
        Text("Loading...")
        ProgressView()
      }
    }
    var emptyIndicator: some View {
        VStack {
            Image("gameIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text("Favorite Masih Kosong")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }
    }
    var errorIndicator: some View {
      CustomEmptyView(
        image: "assetNotFound",
        title: presenter.errorMessage
      ).offset(y: 80)
    }
    var favoriteGameList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(presenter.filteredGames, id: \.id) { game in
                    self.presenter.linkBuilder(gameId: game.id) {
                        GameCard(
                            game: game
                        )
                        .overlay(
                            Button(action: {
                                presenter.updateFavoriteGame(by: game.id)
                            }, label: {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("brandColor"))
                            })
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color("bgCardColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .offset(x: -10, y: 10),
                            alignment: .topTrailing
                        )
                    }
                    .foregroundColor(.white)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
        }
    }
}
