//
//  Genre.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation

struct Genre: Codable, Equatable {
    let id: Int
    let name: String
    var isSelected: Bool = false
    var order: Int? = nil
}
