//
//  StarRatingStorageCollectionViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class StarRatingStorageCollectionViewCell: BaseCollectionViewCell {
    
    let image = UIImageView()
    let label = UILabel()
    
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
        label.text = "test"
        image.image = .setSymbol(.starCircle)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray
        
    }
}
