//
//  DetailView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Core
import Game
import SwiftUI
import CachedAsyncImage

struct DetailView: View {
    var gameId: Int
    @ObservedObject var presenter: GamePresenter<
           Interactor<
               String,
               GameModel,
               GetGameRepository<
                   GetGamesLocaleDataSource,
                   GetGameRemoteDataSource,
                   GameTransformer<GenreTransformer>
               >
           >,
           Interactor<
               String,
               GameModel,
               UpdateFavoriteGameRepository<
                   GetGamesLocaleDataSource,
                   GameTransformer<GenreTransformer>
               >
           >
       >
    var body: some View {
        ScrollView {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorIndicator
            } else {
                content
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                loveButton
            }
        }
        .navigationTitle(presenter.item?.name ?? "")
        .padding()
        .onAppear {
            presenter.getGame(request: String(gameId))
        }
        .alert(item: $presenter.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    @ViewBuilder
    var content: some View {
        VStack {
            imageViewGameDetail
            Text(presenter.item?.name ?? "")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
            VStack(alignment: .leading, spacing: 10) {
                ImageAndTextComponent(rating: presenter.item?.rating, iconName: "star.fill")
                ImageAndTextComponent(iconName: "calendar", textRight: formatDateString(presenter.item?.released))
                genreTags
            }
            gameDescription.padding(.top)
        }
    }
    @ViewBuilder
    var genreTags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(presenter.item?.genres ?? [], id: \.id) { genre in
                    TagComponent(title: genre.name)
                }
            }
            .padding(.top, 10)
        }
    }
    var loadingIndicator: some View {
        VStack {
            Text("Loading...")
            ProgressView()
        }
    }
    var errorIndicator: some View {
        CustomEmptyView(
            image: "assetNotFound",
            title: presenter.errorMessage
        ).offset(y: 80)
    }
    var imageViewGameDetail: some View {
        CachedAsyncImage(url: URL(string: presenter.item?.backgroundImage ?? "")) { image in
            image.resizable()
                .scaledToFill()
                .frame(width: 350, height: 350)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
        } placeholder: {
            ProgressView()
        }.cornerRadius(30).scaledToFit().frame(width: 200).padding(.top)
    }
    var gameDescription: some View {
        VStack(alignment: .leading) {
            Text("Game Description")
                .font(.title2)
                .padding(.bottom, 8)
            Text(presenter.item?.descriptionRaw ?? "")
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
        }
    }
    var loveButton: some View {
        Button(action: {
            presenter.updateFavoriteGame(request: String(gameId))
        }, label: {
            Image(systemName: presenter.item?.favorite ?? false ? "heart.fill" : "heart")
                .foregroundColor(Color("brandColor"))
                .frame(width: 40, height: 40)
                .padding()
        })
    }
}
