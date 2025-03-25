//
//  RealmDramaRepository.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/22/25.
//

import Foundation

protocol DramaRepository: Repository where T == DramaTable {
    func toggleEpisodeWatched(episode: Episodes)
}

final class RealmDramaRepository: RealmRepository<DramaTable>, DramaRepository {
    
    func toggleEpisodeWatched(episode: Episodes) {
        try! realm.write {
            episode.isWatched.toggle()
        }
    }
}
