//
//  RealmDramaRepository.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/22/25.
//

import Foundation

protocol DramaRepository: Repository where T == DramaTable {
    func toggleEpisodeWatched(episode: Episodes)
    func toggleSeasonWant(season: Seasons)
    func changeDramaWant(drama: DramaTable, value: Bool)
}

final class RealmDramaRepository: RealmRepository<DramaTable>, DramaRepository {
    
    func toggleEpisodeWatched(episode: Episodes) {
        try! realm.write {
            episode.isWatched.toggle()
        }
    }
    
    func toggleSeasonWant(season: Seasons) {
        try! realm.write {
            season.wantToWatch.toggle()
        }
    }
    
    func changeDramaWant(drama: DramaTable, value: Bool) {
        try! realm.write {
            drama.wantToWatch = value
        }
    }
}
