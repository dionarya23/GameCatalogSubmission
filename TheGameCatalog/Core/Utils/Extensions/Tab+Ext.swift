//
//  Tab+Ext.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import SwiftUI

enum Tabs: String {
    case home = "Home"
    case favorite = "Favorite"
    case search = "Search"
    case chat = "Community"
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .favorite:
            Image(systemName: "heart")
            Text(self.rawValue)
        case .chat:
            Image(systemName: "person.2")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        }
    }
}
