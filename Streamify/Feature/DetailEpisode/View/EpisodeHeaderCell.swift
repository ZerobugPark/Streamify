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
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func configure(_ item: DramaHeader) {
        titleLabel.text = item.title
        countLabel.text = item.info
        overviewLabel.text = item.overview
    }
    
    override func configureView() {
        imageView.backgroundColor = .gray
    }
}
