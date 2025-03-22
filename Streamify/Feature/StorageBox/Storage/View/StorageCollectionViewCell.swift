//
//  StorageCollectionViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

class StorageCollectionViewCell: BaseCollectionViewCell {
   
    let image = BaseImageView(radius: 10)
    let label = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    
    override func configureHierarchy() {
        contentView.addSubviews(image,label)
    }
    
    override func configureLayout() {
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1.0 / 1.3)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    override func configureView() {
        image.image = .setSymbol(.starCircle)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray
        
    }
}
