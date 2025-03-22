//
//  StreamifyColor.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

extension UIColor {
    
    enum ColorName {
        case primaryYellow
        case baseWhite
        case baseLightGray
        case baseBlack
        
        var color: UIColor {
            switch self {
            case .primaryYellow:
                    .primaryYellow
            case .baseWhite:
                    .baseLightGray
            case .baseLightGray:
                    .baseLightGray
            case .baseBlack:
                    .baseBlack
            }
        }
    }
    
    static func setStreamifyColor(_ type: ColorName) -> UIColor {
        return type.color
    }
}

