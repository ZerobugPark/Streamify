//
//  GenreSelectionView.swift
//  Streamify
//
//  Created by 조다은 on 3/25/25.
//

import UIKit

final class GenreSelectionView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 피드에서 추천받고 싶은\n관심 장르 3가지를 골라주세요."
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .baseWhite
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 순서대로 반영돼요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.id)
        return collectionView
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 장르는 나중에 다시 수정할 수 있어요"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(collectionView)
        addSubview(infoLabel)
        addSubview(doneButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(infoLabel.snp.top).offset(-16)
        }

        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(doneButton.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
    
}
