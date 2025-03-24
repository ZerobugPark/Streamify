//
//  DetailDrama.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/24/25.
//

import Foundation

struct DetailDrama: Decodable {
    let id: Int
    let name: String
    let backdrop_path: String?
    let genres: [GenreData]
    let overview: String
    let seasons: [SeasonData]
    let networks: [Platform]
    let status: String
}

struct GenreData: Decodable {
    let id: Int
    let name: String
}

struct SeasonData: Decodable {
    let episode_count: Int
    let id: Int
    let poster_path: String?
    let name: String
    let season_number: Int
}

struct Platform: Decodable {
    let logo_path: String?
    let name: String
}
