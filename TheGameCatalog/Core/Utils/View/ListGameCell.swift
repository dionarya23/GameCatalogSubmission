//
//  ListGameCell.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 07/06/24.
//

import SwiftUI
import CachedAsyncImage

struct ListGameCell: View {
    let game: GameModel
    var body: some View {
        HStack(spacing: 10) {
            CachedAsyncImage(url: URL(string: game.backgroundImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 100)
                    .cornerRadius(5)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(game.name)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.medium)
                ImageAndTextComponent(rating: game.rating, iconName: "star.fill")
                    .font(.subheadline)
                ImageAndTextComponent(iconName: "calendar", textRight: formatDateString(game.released))
                    .font(.subheadline)
            }
        }
    }
}
