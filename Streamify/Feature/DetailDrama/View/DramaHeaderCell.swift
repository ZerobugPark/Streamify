//
//  DramaHeaderCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit

class DramaHeaderCell: BaseCollectionViewCell {
    let backdropImage = BaseImageView()
    let titleLabel = BaseLabel(fontSize: .body_bold_24, color: .baseWhite)
    let infoLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    
    override func configureHierarchy() {
        addSubviews(backdropImage, titleLabel, infoLabel, overviewLabel)
    }
    
    override func configureLayout() {
        backdropImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImage.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        backdropImage.backgroundColor = .gray
        titleLabel.text = "슬기로운 의사생활"
        infoLabel.text = "시즌 2개 · 방영종료 · 드라마 · 코미디"
        overviewLabel.text = "누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는"
    }
    
}
