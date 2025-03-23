//
//  CommentTableViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import UIKit

import SnapKit

final class CommentTableViewCell: BaseTableViewCell {

    private let image = BaseImageView(radius: 10)
    private let titleLabel = BaseLabel(fontSize: .body_bold_14, color: .baseWhite)
    private let commnetLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    
    override func configureHierarchy() {
        contentView.addSubviews(image, titleLabel, commnetLabel)
        
    }
    
    override func configureLayout() {
        image.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.width.equalTo(contentView.snp.width).multipliedBy(1.0 / 2.5)
            make.height.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(image.snp.trailing).offset(4)
        }
        
        commnetLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(image.snp.trailing).offset(4)
        }
    }
    
    override func configureView() {
        image.image = UIImage(systemName: "star.fill")
        
        
        titleLabel.numberOfLines = 1
        commnetLabel.text = "ssssdadadsadsadas"
        
        contentView.backgroundColor = .setStreamifyColor(.baseBlack)
    }
    
    
    func setupUI(data: Comments) {
     
        titleLabel.text = data.title
        commnetLabel.text = data.comment
        
        if let img = UIImage(data: data.imagePath) {
            image.image = img
        } else {
            image.image = UIImage(systemName: "star.fill")
        }
        
        
    }

}
