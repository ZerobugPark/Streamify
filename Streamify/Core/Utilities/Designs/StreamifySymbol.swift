//
//  StreamifySymbol.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit


extension UIImage {
    
    enum SFSymbol: String {
        case plus = "plus.app"
        case checkmark = "checkmark.square.fill"
        case eye = "eye.fill"
        case pencil = "pencil.circle"
        case starCircle = "star.circle"
        case star = "star.fill"
    }
    
    enum SFSymbolSize {
        case size_regular_14
        case size_bold_14
        case size_regular_16
        case size_bold_16
        case size_regular_18
        case size_bold_18
        case size_regular_20
        case size_bold_20
        case size_regular_22
        case size_bold_22
        case size_regular_24
        case size_bold_24
        
        var pointSize: CGFloat {
            switch self {
            case .size_regular_14, .size_bold_14:
                return 14
            case .size_regular_16, .size_bold_16:
                return 16
            case .size_regular_18, .size_bold_18:
                return 18
            case .size_bold_20, .size_regular_20:
                return 20
            case .size_regular_22, .size_bold_22:
                return 22
            case .size_regular_24, .size_bold_24:
                return 24
            }
        }
        
        
        var weigth: SymbolWeight {
            switch self {
            case .size_regular_14, .size_regular_16, .size_regular_18, .size_regular_20, .size_regular_22, .size_regular_24:
                return .regular
            case .size_bold_14, .size_bold_16, .size_bold_18, .size_bold_20, .size_bold_22, .size_bold_24:
                return .bold
            }
        }
         
    }
    
    
    static func setSymbol(_ type: SFSymbol) -> UIImage? {
        return UIImage(systemName: type.rawValue)
    }
    

    static func setSymbolConfiguration(_ type: SFSymbol, _ config: SFSymbolSize) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(pointSize: config.pointSize, weight: config.weigth)
        return UIImage(systemName: type.rawValue, withConfiguration: configuration)
    }
    
}

