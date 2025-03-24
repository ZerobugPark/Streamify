//
//  StarRatingStorageCollectionViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class StarRatingStorageCollectionViewCell: BaseCollectionViewCell {
    
    let image = UIImageView()
    let starImage = BaseImageView()
    let ratingLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    
    
    override func configureHierarchy() {
        contentView.addSubviews(image,starImage, ratingLabel)
    }
    
    override func configureLayout() {
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1.0 / 1.3)
        }
        starImage.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.leading.equalToSuperview()
            make.size.equalTo(20)
            
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(2)
            make.leading.equalTo(starImage.snp.trailing).offset(4)
            
        }
        
        
    }
    
    override func configureView() {
        
        image.image = .setSymbol(.starCircle)
        
        starImage.image = UIImage(systemName: "star.fill")
        ratingLabel.text = "5.0"
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .setStreamifyColor(.baseBlack)
        
    }
    
    func setupUI(_ data: Rate) {
        
        ratingLabel.text = "\(data.voteAverage)"
        
        if let imgPath = data.imagePath {
            image.image = UIImage(data: imgPath)
        } else {
            image.image = UIImage(systemName: "star.fill")
        }
        
    }
}


