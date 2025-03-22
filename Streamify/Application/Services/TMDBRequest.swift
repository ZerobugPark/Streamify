//
//  TMDBRequest.swift
//  TestStreamify
//
//  Created by 조다은 on 3/21/25.
//

import Foundation

enum TMDBRequest {
    case trending
    case topRated
    case search(query: String)
    case series(id: Int)
    case season(seriesID: Int, seasonNumber: Int)

    var endpoint: TMDBEndpoint {
        switch self {
        case .trending: return .trending
        case .topRated: return .topRated
        case .search: return .search
        case .series(let id): return .series(id: id)
        case .season(let id, let season): return .season(seriesID: id, seasonNumber: season)
        }
    }

    var parameters: [String: String] {
        switch self {
        case .search(let query):
            return ["query": query, "language": Config.Language.korean.rawValue]
        default:
            return ["language": Config.Language.korean.rawValue]
        }
    }

    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: endpoint.fullURL)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIKey.tmdbAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
