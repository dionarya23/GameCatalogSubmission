//
//  SearchPresenter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 08/06/24.
//

import SwiftUI
import Combine

class SearchPresenter: ObservableObject {
    private let router = SearchRouter()
    private var cancellables: Set<AnyCancellable> = []
    private let searchUseCase: SearchUseCase
    @Published var games: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var searchText: String = ""

    init(searchUseCase: SearchUseCase) {
      self.searchUseCase = searchUseCase
    }
    func getSearchGame(by title: String) {
        if !title.isEmpty && title.count >= 3 {
            isLoading = true
            searchUseCase.getSearchGame(by: title)
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
        } else {
            games = []
        }
    }
    func linkBuilder<Content: View>(
      gameId: Int,
      @ViewBuilder content: () -> Content
    ) -> some View {
      NavigationLink(destination: router.makeDetailView(gameId: gameId)) { content() }
    }
}
