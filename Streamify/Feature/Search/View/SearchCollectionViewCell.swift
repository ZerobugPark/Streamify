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

    func configure(with posterPath: String?) {
        guard let posterURL = posterPath else { return }
        posterImageView.image = UIImage(systemName: "photo")

        let baseURL = "https://image.tmdb.org/t/p/w780"
        let urlString = baseURL + posterURL

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }.resume()
    }
}
