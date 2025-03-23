//
//  HorizontalMediaCell.swift
//  Streamify
//
//  Created by 조다은 on 3/23/25.
//

import UIKit
import SnapKit

class HorizontalMediaCell: BaseCollectionViewCell {

    let thumbnailImageView = BaseImageView(radius: 10)
    let titleLabel = BaseLabel(fontSize: .body_bold_24, color: .baseWhite)
    let genreLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)

    override func configureHierarchy() {
        contentView.addSubviews(thumbnailImageView, titleLabel, genreLabel)
    }

    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1.0 / 1.3)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(2)
        }

        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(2)
        }
    }

    override func configureView() {
        thumbnailImageView.image = .setSymbol(.starCircle)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        genreLabel.textAlignment = .center
    }

    func configure(title: String, genre: String?, imagePath: String?) {
        guard let posterPath = imagePath else { return }
        titleLabel.text = title
        genreLabel.text = genre

        let baseURL = "https://image.tmdb.org/t/p/w300"
        let urlString = baseURL + posterPath
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }.resume()
    }
}
