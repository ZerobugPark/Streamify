//
//  APIKey.swift
//  TestStreamify
//
//  Created by 조다은 on 3/21/25.
//

import Foundation

enum TMDBEndpoint {
    static let baseURL = "https://api.themoviedb.org/3"

    case topRated
    case trending
    case similar(id: Int)
    case popular
    case search
    case series(id: Int)
    case season(seriesID: Int, seasonNumber: Int)

    var path: String {
        switch self {
        case .topRated:
            return "/tv/top_rated"
        case .trending:
            return "/trending/tv/day"
        case .similar(let id):
            return "/tv/\(id)/similar"
        case .popular:
            return "/tv/popular"
        case .search:
            return "/search/tv"
        case .series(let id):
            return "/tv/\(id)"
        case .season(let seriesID, let seasonNumber):
            return "/tv/\(seriesID)/season/\(seasonNumber)"
        }
    }

    var fullURL: String {
        return TMDBEndpoint.baseURL + path
    }
}
