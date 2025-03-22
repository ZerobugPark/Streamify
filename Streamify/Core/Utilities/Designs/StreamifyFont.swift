//
//  StreamifyFont.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

extension UIFont {
    enum FontName {
        case body_bold_24
        case body_bold_16
        case body_bold_14
        case body_bold_13
        case body_regular_24
        case body_regular_16
        case body_regular_14
        case body_regular_13
        
        var fontWeight: UIFont.Weight {
            switch self {
            case .body_bold_24, .body_bold_16, .body_bold_14, .body_bold_13:
                return .bold
            case .body_regular_24, .body_regular_16, .body_regular_14, .body_regular_13:
                return .regular
            }
        }
        
        var size: CGFloat {
            switch self {
            case .body_bold_24, .body_regular_24:
                return 24
            case .body_bold_16, .body_regular_16:
                return 16
            case .body_bold_14, .body_regular_14:
                return 14
            case .body_bold_13, .body_regular_13:
                return 13
            }
        }
    }
    
    static func setStreamifyFont(_ type: FontName) -> UIFont {
        return UIFont.systemFont(ofSize: type.size, weight: type.fontWeight)
    }
    
}
