//
//  GameRouter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//

import SwiftUI

class GameRouter {
    func makeDetailView(gameId: Int) -> some View {
        let detailUseCase = Injection.init().provideDetail()
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        return DetailView(presenter: presenter, gameId: gameId)
    }
}
