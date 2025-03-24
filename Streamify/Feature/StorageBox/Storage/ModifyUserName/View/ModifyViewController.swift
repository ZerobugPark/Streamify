//
//  ModifyViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/24/25.
//

import UIKit

import RxCocoa
import RxSwift

final class ModifyViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!\n변경하실 이름을 입력해주세요."
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .setStreamifyColor(.baseWhite)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름 입력"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .left
        return textField
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = NameInputViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.inputName)
            .disposed(by: disposeBag)
        
        viewModel.isValidName
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidName
            .map { $0 ? UIColor.systemBlue : UIColor.lightGray }
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                UserDefaults.standard.set(nameTextField.text, forKey: "userName")
                self.coordinator?.popViewController()
            }
            .disposed(by: disposeBag)
    }
    
}
