//
//  TagComponent.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI

struct TagComponent: View {
    var title: String
    var isSelected: Bool = false
    var body: some View {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(isSelected ? .black : .gray)
                .padding(10)
                .background(isSelected ? Color.white : Color("bgCardColor"))
                .cornerRadius(10)
        }
}

#Preview {
    TagComponent(title: "Action")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
