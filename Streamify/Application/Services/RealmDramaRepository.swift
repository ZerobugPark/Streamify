//
//  RealmDramaRepository.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/22/25.
//

import Foundation

protocol DramaRepository: Repository where T == DramaTable {
    func toggleEpisodeWatched(drama: DramaTable, episode: Episodes)
}

final class RealmDramaRepository: RealmRepository<DramaTable>, DramaRepository {
    
    func toggleEpisodeWatched(drama: DramaTable, episode: Episodes) {
        
        try! realm.write {
            episode.isWatched.toggle()
            print("Progress: \(drama.watchingProgress * 100)%")
            print("DramaType: \(drama.dramaType.rawValue)")
        }
    }
}
