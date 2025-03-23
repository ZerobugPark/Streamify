//
//  StarRatingStorageView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

import SnapKit

final class StarRatingStorageView: BaseView {

    let searchBar = UISearchBar()
    let verticalList = VerticalListView()
    
    override func configureHierarchy() {
        addSubviews(searchBar, verticalList)
    }
    
    override func configureLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        verticalList.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        searchBar.placeholder = "테스트입니다."
    }
    
    
    

}
