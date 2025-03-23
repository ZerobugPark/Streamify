//
//  SearchViewController.swift
//  Streamify
//
//  Created by 조다은 on 3/24/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    
    // MARK: - UI Components

    private let searchBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()

    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .lightGray
        return imageView
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "작품, 인물 등"
        textField.textColor = .white
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let verticalListView = VerticalListView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(searchBarContainerView)
        searchBarContainerView.addSubview(searchIconImageView)
        searchBarContainerView.addSubview(searchTextField)
        view.addSubview(cancelButton)
        view.addSubview(verticalListView)

        searchBarContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-8)
            make.height.equalTo(36)
        }

        searchIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(20)
        }

        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBarContainerView)
            make.trailing.equalToSuperview().inset(16)
        }

        verticalListView.snp.makeConstraints { make in
            make.top.equalTo(searchBarContainerView.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

