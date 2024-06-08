//
//  CarouselCard.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CarouselCard: View {
    var gameUpdated: GameModel
    var body: some View {
        CachedAsyncImage(url: URL(string: gameUpdated.backgroundImage)) { image in
          image
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width - 40, height: 200)
            .cornerRadius(10)
            .overlay(
                CardTextView(gameUpdated.name, convertDate(dateString: gameUpdated.released), gameUpdated.rating)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .background(Color("bgCardColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .offset(x: 0, y: 0),
                alignment: .bottom
            )
        } placeholder: {
          ProgressView()
        }
    }

    @ViewBuilder
    func CardTextView(_ gameTitle: String, _ gameYear: String, _ gameRating: Double?) -> some View {
        HStack(alignment: .firstTextBaseline) {
          Text("\(gameTitle) \(gameYear)")
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
           Spacer()
            ImageAndTextComponent(rating: gameRating!, iconName: "star.fill")
        }
        .padding(.top, -10)
        .padding(.leading)
        .padding(.trailing)
    }

    func convertDate(dateString: String?) -> String {
        if let dateString = dateString {
            let year = String(dateString.prefix(4))
            return year
        } else {
            return ""
        }
    }
}
