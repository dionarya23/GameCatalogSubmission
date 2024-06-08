//
//  FavoritePresenter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI
import Combine

class FavoritePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let router = FavoriteRouter()
    private let favoriteUseCase: FavoriteUseCase
    private var successAddMessage = "Berhasil menambahkan game ke favorite"
    private var successRemoveMessage = "Berhasil menghapus game dari favorite"
    @Published var games: [GameModel] = []
    @Published var genres: [GenreModel] = []
    @Published var filteredGames: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var emptyGameMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var selectedGenreId: Int = -1
    @Published var alertItem: AlertItem?
    init(favoriteUseCase: FavoriteUseCase) {
      self.favoriteUseCase = favoriteUseCase
    }
    func filterByGenre(genreId: Int) {
        if selectedGenreId != genreId {
           selectedGenreId = genreId
        } else {
           selectedGenreId = -1
        }

        $selectedGenreId.combineLatest(self.$games)
            .map { (genreId, startingGames) -> [GameModel] in
                return startingGames.filter { (game) -> Bool in
                    guard genreId != -1 else {
                        return true
                    }
                    return game.genres.contains { $0.id == genreId }
                }
            }.sink { [weak self] (returnedGames) in
                self?.filteredGames = returnedGames
            }.store(in: &cancellables)
    }
    func getGamesAndGenres() {
        isLoading = true
        favoriteUseCase.getFavoriteGame()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isError = true
                self.isLoading = false
              case .finished:
                self.isLoading = false
              }
            }, receiveValue: { game in
              self.games = game
              self.filteredGames = game
            })
            .store(in: &cancellables)
        genres = favoriteUseCase.getGenres()
    }
    func updateFavoriteGame(by gameId: Int) {
        isLoading = true
        favoriteUseCase.updatedFavoriteGame(by: gameId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isError = true
                self.isLoading = false
              case .finished:
                self.isLoading = false
              }
            }, receiveValue: { game in
                self.games = self.games.filter {
                    return $0.id != game.id
                }
                self.filteredGames = self.filteredGames.filter {
                    return $0.id != game.id
                }
            })
            .store(in: &cancellables)
        showLoveAlert(description: successRemoveMessage)
    }
    private func showLoveAlert(description: String) {
         alertItem = AlertItem(title: Text("Berhasil!"),
                               message: Text(description),
                               dismissButton: .default(Text("Ok")))
     }
    func linkBuilder<Content: View>(
      gameId: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(destination: router.makeDetailView(gameId: gameId)) { content() }
    }
}
