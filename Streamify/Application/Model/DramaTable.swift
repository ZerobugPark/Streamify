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
    case wantToWatch = "보고싶어요"
    case watching = "보는중"
    case watched = "봤어요"
}

final class DramaTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var titleID: Int
    @Persisted var title: String
    @Persisted var vote_average: Double
    @Persisted var genre: String
    @Persisted var imagePath: String
    @Persisted var comment: String
    @Persisted var watching: Float
    @Persisted var episodes: List<Episodes>
    @Persisted var dramaType: DramaType
}

class Episodes: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var number: Int
    @Persisted var isWatched: Bool

    @Persisted(originProperty: "episodes") var folder: LinkingObjects<DramaTable>

    convenience init(number: Int, isWatched: Bool) {
        self.init()
        self.number = number
        self.isWatched = isWatched
    }
}

