//
//  ContentView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Core
import Game
import SwiftUI
import GameCommunity

struct ContentView: View {
    @EnvironmentObject var communityPresenter: GameCommunityPresenter<
        Interactor<RequestLogin, UserModel, LoginRepository<LoginRemoteDataSource>>,
        Interactor<String, [ChatModel], GetChatsRepository<GetChatsRemoteDataSource>>,
        Interactor<RequestRegister, UserModel, RegisterRepository<RegisterRemoteDataSource>>,
        Interactor<String, UserModel, GetUsersRepository<GetUsersRemoteDataSource>>,
        Interactor<ChatModel, Bool, SendChatRepository<SendChatRemoteDataSource>>
    >
    @EnvironmentObject var homePresenter: GetListPresenter<
            String, GameModel,
            Interactor<
                String, [GameModel],
                GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer<GenreTransformer>>
            >
        >
    @EnvironmentObject var favoritePresenter: GameFavoritePresenter<
            Interactor<
                String, [GameModel],
                GetFavoriteGamesRepository<GetFavoriteGamesLocaleDataSource, GamesTransformer<GenreTransformer>>
            >,
            Interactor<
                String, GameModel,
                UpdateFavoriteGameRepository<GetGamesLocaleDataSource, GameTransformer<GenreTransformer>>
            >
        >
        @EnvironmentObject var searchPresenter: SearchPresenter<
            GameModel,
            Interactor<
                String, [GameModel],
                SearchGamesRepository<GetGamesRemoteDataSource, GamesTransformer<GenreTransformer>>
            >
        >
    @State private var activeTab: Tabs = .home
    var body: some View {
        TabView(selection: $activeTab) {
            HomeView(presenter: homePresenter)
                .tag(Tabs.home)
                .tabItem { Tabs.home.tabContent }
            FavoriteView(presenter: favoritePresenter)
                .tag(Tabs.favorite)
                .tabItem { Tabs.favorite.tabContent }
            ChatView(presenter: communityPresenter)
                .tag(Tabs.chat)
                .tabItem { Tabs.chat.tabContent }
            SearchView(presenter: searchPresenter)
                .tag(Tabs.search)
                .tabItem { Tabs.search.tabContent }
        }
        .accentColor(Color("brandColor"))
    }
}
