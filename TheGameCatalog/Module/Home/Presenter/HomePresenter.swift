//
//  HomePresenter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 05/06/24.
//
import SwiftUI
import Combine

class HomePresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let router = HomeRouter()
    private let homeUseCase: HomeUseCase
    @Published var games: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    init(homeUseCase: HomeUseCase) {
      self.homeUseCase = homeUseCase
    }

    func getGames() {
        isLoading = true
        homeUseCase.getGames()
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
            })
            .store(in: &cancellables)
    }
    func linkBuilder<Content: View>(
      gameId: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(destination: router.makeDetailView(gameId: gameId)) { content() }
    }
    func linkBuilderListGame<Content: View> (
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeListGameView(title: title)) { content() }
    }
    func linkBuilderProfile<Content: View>  (
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeProfileView()) { content() }
    }
}
