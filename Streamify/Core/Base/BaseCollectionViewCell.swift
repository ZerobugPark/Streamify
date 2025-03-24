//
//  BaseCollectionViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        self.backgroundColor = .setStreamifyColor(.baseBlack)
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
