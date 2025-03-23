//
//  EpisodeCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit

class EpisodeCell: BaseCollectionViewCell {
    
    let imageView = BaseImageView()
    let titleLabel = BaseLabel(fontSize: .body_bold_24, color: .baseWhite)
    let timeLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    let dateLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    
    let checkButton = ActionButton(title: "", image: .checkmark)
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, timeLabel, dateLabel, overviewLabel, checkButton)
    }
    
    override func configureLayout() {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
}
