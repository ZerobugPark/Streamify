//
//  CompositionalHeaderReusableView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class CompositionalHeaderReusableView: UICollectionReusableView {
        
    let titleLabel = BaseLabel(fontSize: .body_bold_16, color: .baseWhite)
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configurationLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationLayout() {
        addSubviews(titleLabel, lineView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.width.equalTo(titleLabel.snp.width).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(2)
            lineView.backgroundColor = .setStreamifyColor(.baseWhite)
        }
    
    }
}
