//
//  GamePresenter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//
import SwiftUI
import Combine

class GamePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let router = GameRouter()
    private let gameUseCase: GameListUseCase
    @Published var listGame: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    init(gameUseCase: GameListUseCase) {
      self.gameUseCase = gameUseCase
    }
    func getGames() {
        isLoading = true
        gameUseCase.getAllGame()
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
              self.listGame = game
            })
            .store(in: &cancellables)
    }
    func linkBuilder<Content: View>(
      gameId: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(destination: router.makeDetailView(gameId: gameId)) { content() }
    }
}
