//
//  EpisodeHeaderCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit

class EpisodeHeaderCell: BaseCollectionViewCell {
    let imageView = BaseImageView()
    let titleLabel = BaseLabel(fontSize: .body_bold_24, color: .baseWhite)
    let countLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, countLabel, overviewLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(imageView.snp.leading).inset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func configure(_ item: EpisodeHeader) {
        titleLabel.text = item.title
        countLabel.text = item.info
        overviewLabel.text = item.overview
    }
    
    override func configureView() {
        imageView.backgroundColor = .gray
    }
}
