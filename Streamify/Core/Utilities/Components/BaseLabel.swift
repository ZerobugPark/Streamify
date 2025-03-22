//
//  BaseLabel.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class BaseLabel: UILabel {

    init() {
        super.init(frame: .zero)
    }
    
    convenience init(fontSize: UIFont.FontName, color: UIColor.ColorName) {
        self.init()
        
        font = .setStreamifyFont(fontSize)
        
        textColor = .setStreamifyColor(color)
        numberOfLines = 4 // Line 수
        lineBreakMode = .byTruncatingTail  // 뒤에 ...
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
