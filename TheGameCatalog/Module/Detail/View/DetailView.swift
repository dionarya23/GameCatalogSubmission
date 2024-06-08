//
//  DetailView.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI
import CachedAsyncImage

struct DetailView: View {
    @ObservedObject var presenter: DetailPresenter
    var gameId: Int
    var body: some View {
        ScrollView {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorIndicator
            } else {
                VStack {
                    CachedAsyncImage(url: URL(string: presenter.game?.backgroundImage ?? "")) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 350)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }.cornerRadius(30).scaledToFit().frame(width: 200).padding(.top)
                    Text(presenter.game?.name ?? "")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding()
                    VStack(alignment: .leading, spacing: 10) {
                        ImageAndTextComponent(rating: presenter.game?.rating, iconName: "star.fill")
                        ImageAndTextComponent(iconName: "calendar",
                                              textRight: formatDateString(presenter.game?.released))
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(presenter.game?.genres ?? [], id: \.id) { genre in
                                    TagComponent(title: genre.name)
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                    gameDescription.padding(.top)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                loveButton
            }
        }
        .navigationTitle(presenter.game?.name ?? "")
        .padding()
        .onAppear {
            presenter.getDetailGame(by: gameId)
        }
        .alert(item: $presenter.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

extension DetailView {
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
    var gameDescription: some View {
       VStack(alignment: .leading) {
           Text("Game Description")
               .font(.title2)
               .padding(.bottom, 8)
           Text(presenter.game?.descriptionRaw ?? "")
               .font(.subheadline)
               .fontWeight(.light)
               .multilineTextAlignment(.leading)
       }
   }
    var loveButton: some View {
       Button(action: {
           presenter.updateFavoriteGame(by: gameId)
       }, label: {
           Image(systemName: presenter.game?.favorite ?? false ? "heart.fill" : "heart")
               .foregroundColor(Color("brandColor"))
               .frame(width: 40, height: 40)
               .padding()
       })
   }
}
