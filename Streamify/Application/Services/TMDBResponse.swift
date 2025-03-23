//
//  TMDBResponse.swift
//  TestStreamify
//
//  Created by 조다은 on 3/21/25.
//

import Foundation

struct TMDBResponse: Codable {
    let page: Int
    let results: [MediaItem]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MediaItem: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let genreIDS: [Int]

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
    }
}

typealias TopRatedResult = MediaItem
typealias TrendingResult = MediaItem
typealias SimilarResult = MediaItem
typealias PopularResult = MediaItem
typealias SearchResult = MediaItem
//typealias RecommendResult = MediaItem
