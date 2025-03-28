//
//  BaseImageView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit


final class BaseImageView: UIImageView {
    
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(radius: CGFloat) {
        self.init()
        
        layer.cornerRadius = radius
        layer.borderWidth = 0
        clipsToBounds = true
        contentMode = .scaleAspectFill
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
