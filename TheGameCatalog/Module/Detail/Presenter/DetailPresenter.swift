//
//  DetailPresenter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI
import Combine

class DetailPresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let detailUseCase: DetailUseCase
    private var successAddMessage = "Berhasil menambahkan game ke favorite"
    private var successRemoveMessage = "Berhasil menghapus game dari favorite"

    @Published var game: GameModel?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var alertItem: AlertItem?

    init(detailUseCase: DetailUseCase) {
      self.detailUseCase = detailUseCase
    }
    func getDetailGame(by gameId: Int) {
        isLoading = true
        detailUseCase.getDetailGame(by: gameId)
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
              self.game = game
            })
            .store(in: &cancellables)
    }
    func updateFavoriteGame(by gameId: Int) {
        isLoading = true
        detailUseCase.updateFavoriteGame(by: gameId)
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
              self.game = game
            })
            .store(in: &cancellables)
        showLoveAlert(description: game?.favorite ?? false ? successRemoveMessage : successAddMessage)
    }
   private func showLoveAlert(description: String) {
        alertItem = AlertItem(title: Text("Berhasil!"),
                              message: Text(description),
                              dismissButton: .default(Text("Ok")))
    }
}
