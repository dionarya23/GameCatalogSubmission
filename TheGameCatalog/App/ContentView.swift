//
//  ContentView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var homePresenter: HomePresenter
    @EnvironmentObject var favoritePresenter: FavoritePresenter
    @EnvironmentObject var searchPresenter: SearchPresenter
    @State private var activeTab: Tabs = .home
    var body: some View {
        TabView(selection: $activeTab) {
            HomeView(presenter: homePresenter)
                .tag(Tabs.home)
                .tabItem { Tabs.home.tabContent }
            FavoriteView(presenter: favoritePresenter)
                .tag(Tabs.favorite)
                .tabItem { Tabs.favorite.tabContent }
            SearchView(presenter: searchPresenter)
                .tag(Tabs.search)
                .tabItem { Tabs.search.tabContent }
        }
        .accentColor(Color("brandColor"))
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
