//
//  NameInputView.swift
//  Streamify
//
//  Created by 조다은 on 3/25/25.
//

import UIKit
import SnapKit

final class NameInputView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!\n이름을 입력해주세요."
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .setStreamifyColor(.baseWhite)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름 입력"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .left
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primaryYellow
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(nameTextField)
        addSubview(nextButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(safeAreaLayoutGuide).offset(30)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }

}
