//
//  GameCard.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 06/06/24.
//

import SwiftUI
import CachedAsyncImage

struct GameCard: View {
    var game: GameModel
    var body: some View {
        CachedAsyncImage(url: URL(string: game.backgroundImage)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 270)
                .cornerRadius(10)
                .overlay(cardText
                    .padding(.top, -10)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                    .background(Color("bgCardColor"))
                    .offset(x: 0, y: 0),
                    alignment: .bottom)
        } placeholder: {
            ProgressView()
        }
    }
    var cardText: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(game.name)
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                    .bold()
                ImageAndTextComponent(rating: game.rating, iconName: "star.fill")
                    .font(.subheadline)
                ImageAndTextComponent(iconName: "calendar", textRight: formatDateString(game.released))
                    .font(.subheadline)
            }
            Spacer()
        }
    }

}
