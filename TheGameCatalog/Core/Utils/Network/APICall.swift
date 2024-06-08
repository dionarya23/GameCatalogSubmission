//
//  APICall.swift
//  TheGameCatalog
//
//  Created by Dion Arya Pamungkas on 04/06/24.
//

import Foundation

struct APIEndpoint {
  static let baseUrl = "https://rawg-mirror.vercel.app/api/games"
}

protocol Endpoint {
  var url: String { get }
}

enum Endpoints {
  enum Gets: Endpoint {
    case games
    case gamesUpdated
    case detail
    case search

    public var url: String {
      switch self {
      case .games: return "\(APIEndpoint.baseUrl)"
      case .gamesUpdated: return "\(APIEndpoint.baseUrl)?ordering=updated"
      case .detail: return "\(APIEndpoint.baseUrl)/"
      case .search: return "\(APIEndpoint.baseUrl)?search="
      }
    }
  }
}
