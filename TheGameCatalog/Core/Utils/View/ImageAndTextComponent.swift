//
//  ImageAndTextComponent.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI

struct ImageAndTextComponent: View {
    var rating: Double?
    var iconName: String
    var textRight: String?

    var body: some View {
        HStack {
            if iconName == "star.fill" {
                Image(systemName: iconName)
                    .foregroundColor(.yellow)
            } else {
                Image(systemName: iconName)
            }

            if let rating = rating {
                Text(String(format: "%.1f", rating))
                    .fontWeight(.bold)
            } else {
                Text(textRight ?? "")
            }
        }
    }
}

#Preview {
    ImageAndTextComponent(rating: 4.5, iconName: "star.fill")
        .preferredColorScheme(.dark)
}
