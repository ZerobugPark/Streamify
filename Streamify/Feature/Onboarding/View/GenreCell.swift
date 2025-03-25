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
        label.textColor = .baseWhite
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.baseLightGray.cgColor
        return view
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        return label
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
        containerView.addSubview(badgeLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        badgeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(20)
        }

        containerView.clipsToBounds = false
    }

    func configure(with genre: Genre) {
        titleLabel.text = genre.name
        
        print("badge======", genre.order)

        if genre.isSelected {
            containerView.backgroundColor = UIColor.systemBlue
            titleLabel.textColor = .white
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            containerView.backgroundColor = .baseBlack
            titleLabel.textColor = .white
            containerView.layer.borderColor = UIColor.baseLightGray.cgColor
        }

        if let order = genre.order {
            print("badge======", order)
            badgeLabel.isHidden = false
            badgeLabel.text = "\(order)"
        } else {
            badgeLabel.isHidden = true
        }
    }
}
