//
//  TheGameCatalogApp.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI

@main
struct TheGameCatalogApp: App {
    let homePresenter = HomePresenter(homeUseCase: Injection.init().provideHome())
    let favoritePresenter = FavoritePresenter(favoriteUseCase: Injection.init().provideFavorite())
    let searchPresenter = SearchPresenter(searchUseCase: Injection.init().provideSearch())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homePresenter)
                .environmentObject(favoritePresenter)
                .environmentObject(searchPresenter)
        }
    }
}
