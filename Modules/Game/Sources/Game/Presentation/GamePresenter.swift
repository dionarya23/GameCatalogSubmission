//
//  File.swift
//  
//
//  Created by Dion Arya Pamungkas on 05/07/24.
//

import Core
import Foundation
import Combine
import SwiftUI

public class GamePresenter<
    GameUseCase: UseCase,
    FavoriteUseCase: UseCase
>: ObservableObject where
GameUseCase.Request == String,
GameUseCase.Response == GameModel,
FavoriteUseCase.Request == String,
FavoriteUseCase.Response == GameModel
{
    private var cancellables: Set<AnyCancellable> = []

    private let gameUseCase: GameUseCase
    private let favoriteUseCase: FavoriteUseCase
    private var successAddMessage = "Berhasil menambahkan game ke favorite"
    private var successRemoveMessage = "Berhasil menghapus game dari favorite"

    @Published public var item: GameModel?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    @Published public var alertItem: AlertItem?

    public init(gameUseCase: GameUseCase, favoriteUseCase: FavoriteUseCase) {
      self.gameUseCase = gameUseCase
      self.favoriteUseCase = favoriteUseCase
    }
    
    public func getGame(request: GameUseCase.Request) {
      isLoading = true
      self.gameUseCase.execute(request: request)
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
        }, receiveValue: { item in
          self.item = item
        })
        .store(in: &cancellables)
    }

    public func updateFavoriteGame(request: FavoriteUseCase.Request) {
      self.favoriteUseCase.execute(request: request)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
          switch completion {
          case .failure:
            self.errorMessage = String(describing: completion)
          case .finished:
            self.isLoading = false
          }
        }, receiveValue: { item in
          self.item = item
        })
        .store(in: &cancellables)
        showLoveAlert(description: item?.favorite ?? false ? successRemoveMessage : successAddMessage)
    }
    private func showLoveAlert(description: String) {
        alertItem = AlertItem(title: Text("Berhasil!"),
                               message: Text(description),
                               dismissButton: .default(Text("Ok")))
     }
}
