//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 18/07/24.
//

import SwiftUI
import Foundation
import Combine
import Core

public class GameFavoritePresenter<
    GetFavoriteUseCase: UseCase,
    UpdateFavroriteUseCase: UseCase
>: ObservableObject where
GetFavoriteUseCase.Request == String,
GetFavoriteUseCase.Response == [GameModel],
UpdateFavroriteUseCase.Request == String,
UpdateFavroriteUseCase.Response == GameModel
{
    private var cancellables: Set<AnyCancellable> = []
    private let updateFavroriteUseCase: UpdateFavroriteUseCase
    private let getFavoriteUseCase: GetFavoriteUseCase
    public var successRemoveMessage = "Berhasil menghapus game dari favorite"
    @Published public var items: [GameModel] = []
    @Published public var genres: [GenreModel] = [
        GenreModel(id: 4, name: "Action"),
        GenreModel(id: 51, name: "Indie"),
        GenreModel(id: 3, name: "Adventure"),
        GenreModel(id: 7, name: "Puzzle"),
        GenreModel(id: 2, name: "Shooter"),
        GenreModel(id: 5, name: "RPG")
    ];
    @Published public var filteredGames: [GameModel] = []
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    @Published public var selectedGenreId: Int = -1
    @Published public var alertItem: AlertItem?
    
    public init(getFavoriteUseCase: GetFavoriteUseCase, updateFavroriteUseCase: UpdateFavroriteUseCase) {
      self.updateFavroriteUseCase = updateFavroriteUseCase
      self.getFavoriteUseCase = getFavoriteUseCase
    }
    
    public func filterByGenre(genreId: Int) {
        if selectedGenreId != genreId {
           selectedGenreId = genreId
        } else {
           selectedGenreId = -1
        }

        $selectedGenreId.combineLatest(self.$items)
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

    public func getGames() {
      isLoading = true
      self.getFavoriteUseCase.execute(request: nil)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
          switch completion {
          case .failure (let error):
            self.errorMessage = error.localizedDescription
            self.isError = true
            self.isLoading = false
          case .finished:
            self.isLoading = false
          }
        }, receiveValue: { items in
          self.items = items
          self.filteredGames = items
        })
        .store(in: &cancellables)
    }

    public func updateFavoriteGame(request: UpdateFavroriteUseCase.Request) {
      self.updateFavroriteUseCase.execute(request: request)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
          switch completion {
          case .failure:
            self.errorMessage = String(describing: completion)
          case .finished:
            self.isLoading = false
          }
        }, receiveValue: { game in
            self.items = self.items.filter {
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
}
