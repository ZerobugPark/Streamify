//
//  DramaPlatformCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit

class DramaPlatformCell: BaseCollectionViewCell {
    
    let image = BaseImageView()
    let chevron = {
       let image = BaseImageView()
        image.image = UIImage(systemName: "chevron.right")
        return image
    }()
    
    override func configureHierarchy() {
        addSubviews(image,chevron)
        image.backgroundColor = .blue
    }
    
//    override func configureLayout() {
//        image.snp.makeConstraints { make in
//            make.size.equalTo(25)
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().inset(10)
//        }
//        chevron.snp.makeConstraints { make in
//            make.size.equalTo(25)
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().inset(10)
//        }
//    }
}
