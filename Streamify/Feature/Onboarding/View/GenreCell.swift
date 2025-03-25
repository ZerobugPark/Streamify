//
//  GenreCell.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import SnapKit

class GenreCell: UICollectionViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }

    func configure(with genre: Genre) {
        if let order = genre.order {
            titleLabel.text = "\(order). \(genre.name)"
        } else {
            titleLabel.text = genre.name
        }

        if genre.isSelected {
            containerView.backgroundColor = UIColor.systemBlue
            titleLabel.textColor = .white
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            containerView.backgroundColor = .white
            titleLabel.textColor = .black
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
