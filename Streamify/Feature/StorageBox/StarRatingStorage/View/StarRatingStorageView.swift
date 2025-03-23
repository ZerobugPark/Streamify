//
//  StarRatingStorageView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

import SnapKit

final class StarRatingStorageView: BaseView {

    let verticalList = VerticalListView()
    
    override func configureHierarchy() {
        addSubview(verticalList)
    }
    
    override func configureLayout() {
        verticalList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
