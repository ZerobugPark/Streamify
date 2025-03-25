//
//  StroageStruct.swift
//  Streamify
//
//  Created by youngkyun park on 3/24/25.
//

import Foundation
import RxDataSources

struct Comments {
    var titleID: Int
    var title: String
    var imagePath: Data?
    var comment: String
}

struct Rate {
    var titleID: Int
    var title: String
    var imagePath: Data?
    var voteAverage: Double
}

enum StorageSectionItem { //셀의 종류
    case firstSection(DramaTable)
    case secondSection(DramaTable)
    case thirdSection(DramaTable)
}

enum ListViewSectionModel { //섹션 정의
    case first(header: String ,[StorageSectionItem])
    case second(header: String,[StorageSectionItem])
    case third(header: String, [StorageSectionItem])
    
}

extension ListViewSectionModel: SectionModelType {
    
    typealias Item = StorageSectionItem
    
    var items: [StorageSectionItem] {
        switch self {
        case .first(_, let items):
            return items
        case .second(_, let items):
            return items
        case .third(_, let items):
            return items
        }
    }
    
    
    var header: String {
        switch self {
        case .first(let header, _):
            return header
        case .second(let header, _):
            return header
        case .third(let header, _):
            return header
        }
    }

    init(original: ListViewSectionModel, items: [Self.Item]) {
        self = original
        
    }
}


