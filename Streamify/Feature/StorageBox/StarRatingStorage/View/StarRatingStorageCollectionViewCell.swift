//
//  StarRatingStorageCollectionViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class StarRatingStorageCollectionViewCell: BaseCollectionViewCell {
    
    let image = BaseImageView(radius: 10)
    let starImage = BaseImageView()
    let ratingLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    
    
    override func configureHierarchy() {
        contentView.addSubviews(image,starImage, ratingLabel)
    }
    
    override func configureLayout() {
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1.0 / 1.15)
        }
        starImage.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(2)
            make.leading.equalToSuperview()
            make.size.equalTo(20)
            
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(4)
            make.leading.equalTo(starImage.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-4)
            
        }
        
        
    }
    
    override func configureView() {
        
        starImage.image = .setSymbol(.star)
        starImage.tintColor = .setStreamifyColor(.primaryYellow)
        ratingLabel.numberOfLines = 1
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
    }
    
    func setupUI(_ data: Rate) {
        
//        if let rating = data.voteAverage {
//            ratingLabel.text = "\(rating)"
//        } else {
//            ratingLabel.text = "등록된 평점이 없습니다"
//        }
        ratingLabel.text = "\(data.voteAverage)"
        
        if let imgPath = data.imagePath {
            image.image = UIImage(data: imgPath)
        } else {
            image.image = UIImage(systemName: "star.fill")
        }
        
    }
}


