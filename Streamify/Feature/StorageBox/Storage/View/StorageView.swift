//
//  StorageView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

import SnapKit

final class StorageView: BaseView {

   
    let wantToWatchButton = ActionButton(title: "0", subTitle: "보고싶어요")
    let watchedButton = ActionButton(title: "0", subTitle: "봤어요")
    let watchingButton = ActionButton(title: "0", subTitle: "보는중")
    let commentButton = ActionButton(title: "0", subTitle: "코멘트")
    let ratingButton = ActionButton(title: "0", subTitle: "별점")
    
    let storageList = CompositionalListView()
    
    
    private let stackView = UIStackView()
    
    override func configureHierarchy() {
        addSubviews(stackView, storageList)
        
        stackView.addArrangedSubviews(wantToWatchButton,watchedButton,watchingButton, commentButton, ratingButton)
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(self)
        }
        
        storageList.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(self)
        }
        
        wantToWatchButton.snp.makeConstraints { make in
            make.width.equalTo(105)
        }
        
    }
    
    override func configureView() {
        
        stackView.distribution = .fillProportionally
        //stackView.spacing = 4
        stackView.axis = .horizontal
        
        [wantToWatchButton, watchedButton, watchingButton, commentButton, ratingButton].enumerated().forEach { index, button in
            button.tag = index
        }
        
    }
    
    
}
