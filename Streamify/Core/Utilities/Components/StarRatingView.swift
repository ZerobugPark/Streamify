//
//  StarRatingView.swift
//  Streamify
//
//  Created by youngkyun park on 3/21/25.
//

import UIKit

import Cosmos
import SnapKit

final class StarRatingView: BaseView {

    let starRating = CosmosView()
    
    override func configureHierarchy() {
        addSubview(starRating)
    }
    
    override func configureLayout() {
        
        starRating.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    override func configureView() {
        starRating.settings.totalStars = 5  // 별 5개
        starRating.settings.fillMode = .precise  // 0.1 단위로 조절 가능
        starRating.settings.starSize = 30  // 별 크기 설정
        starRating.settings.starMargin = 8  // 별 사이 간격
        starRating.settings.minTouchRating = 0  // ⭐️ 최소 별점을 0으로 설정
        starRating.rating = 0.0  // 초기 별점 설정

    }
}
