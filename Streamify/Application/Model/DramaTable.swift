//
//  DramaTable.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/22/25.
//

import Foundation
import RealmSwift


enum DramaType: String, PersistableEnum {
    case none = "안봤어요"
    case watching = "보는중"
    case watched = "봤어요"
}

final class DramaTable: Object {
    
    var watchingProgress: Float {
        let totalEpisodes = seasons.reduce(0) { $0 + $1.episodes.count }
        let watchedEpisodes = seasons.reduce(0) { $0 + $1.episodes.filter { $0.isWatched }.count }
        
        return totalEpisodes == 0 ? 0.0 : Float(watchedEpisodes) / Float(totalEpisodes)
    }
    
    func episodeProgress(for season: Seasons) -> Float {
        let watchedCount = season.episodes.filter { $0.isWatched }.count
        return season.episodes.isEmpty ? 0.0 : Float(watchedCount) / Float(season.episodes.count)
    }

    var dramaType: DramaType {
        switch watchingProgress {
        case 0.0: return .none
        case 1.0: return .watched
        default: return .watching
        }
    }
    
    @Persisted(primaryKey: true) var titleID: Int
    @Persisted var title: String
    @Persisted var vote_average: Double?
    @Persisted var genre: String
    @Persisted var imagePath: String
    @Persisted var comment: String
    @Persisted var wantToWatch: Bool
    @Persisted var seasons: List<Seasons>
    
    convenience init(titleID: Int, title: String, vote_average: Double?, genre: String, imagePath: String, comment: String, wantToWatch: Bool, seasons: List<Seasons>) {
        self.init()
        self.titleID = titleID
        self.title = title
        self.vote_average = vote_average
        self.genre = genre
        self.imagePath = imagePath
        self.comment = comment
        self.wantToWatch = wantToWatch
        self.seasons = seasons
    }
    
}

class Seasons: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var episodes: List<Episodes>
    @Persisted var wantToWatch: Bool
    @Persisted(originProperty: "seasons") var drama: LinkingObjects<DramaTable>

    convenience init(episodes: List<Episodes>, wantToWatch: Bool) {
        self.init()
        self.episodes = episodes
        self.wantToWatch = wantToWatch
    }
}


class Episodes: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isWatched: Bool
    @Persisted var seasonIndex: Int

    @Persisted(originProperty: "episodes") var seasons: LinkingObjects<Seasons>

    convenience init(isWatched: Bool, seasonIndex: Int) {
        self.init()
        self.isWatched = isWatched
        self.seasonIndex = seasonIndex
    }
}

