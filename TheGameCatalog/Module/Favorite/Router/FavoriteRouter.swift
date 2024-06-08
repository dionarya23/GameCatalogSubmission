//
//  FavoriteRouter.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI

class FavoriteRouter {
    func makeDetailView(gameId: Int) -> some View {
        let detailUseCase = Injection.init().provideDetail()
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        return DetailView(presenter: presenter, gameId: gameId)
    }
}
