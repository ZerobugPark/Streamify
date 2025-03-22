//
//  StorageViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit
import SnapKit

class StorageViewController: UIViewController {

    
    let testLabel = BaseLabel(fontSize: .body_bold_24, color: .baseLightGray)
//    let testButton = ActionButton(title: "테스트", image: .checkmark)
    let testButton = ActionButton(title: "테스트2", subTitle: "hello")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        view.backgroundColor = .baseBlack
        
        testLabel.text = "안녕하세요"
        testLabel.backgroundColor = .baseWhite
        
        testButton.updateSubtitle("12")
        
    }
    
    private func config() {
        [testLabel, testButton].forEach {
            view.addSubview($0)
        }

        testLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
        }
        
        testButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    


}
