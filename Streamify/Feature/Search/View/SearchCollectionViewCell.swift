//
//  SearchCollectionViewCell.swift
//  Streamify
//
//  Created by 조다은 on 3/24/25.
//

import UIKit
import SnapKit

final class SearchCollectionViewCell: UICollectionViewCell {

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(imageURL: URL?) {
        // 나중에 Kingfisher 등 이미지 로딩 라이브러리 적용 가능
        // 현재는 system image 대체
        posterImageView.image = UIImage(systemName: "photo")
    }
}
