//
//  DramaEpisodeCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit

class DramaEpisodeCell: BaseCollectionViewCell {
    private let imageView = BaseImageView()
    private let titleLabel = BaseLabel(fontSize: .body_bold_14, color: .baseWhite)
    private let countLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, countLabel)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 10
    }
    
    func configure(_ item: DramaEpisode) {
        imageView.image = item.image
        titleLabel.text = item.title
        countLabel.text = "\(item.episodeCount)개 에피소드"
    }
    
}
