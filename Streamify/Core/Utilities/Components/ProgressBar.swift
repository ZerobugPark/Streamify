//
//  ProgressBar.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/22/25.
//

import UIKit

final class ProgressBar: UIProgressView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        trackTintColor = .lightGray
        progressTintColor = .setStreamifyColor(.primaryYellow)
        progress = 0.0
        transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
