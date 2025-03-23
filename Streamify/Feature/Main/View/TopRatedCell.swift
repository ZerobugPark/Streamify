//
//  TopRatedCell.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import SnapKit

class TopRatedCell: UICollectionViewCell {

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
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

    func configure(with posterPath: String) {
        // 기본 플레이스홀더
        posterImageView.image = UIImage(systemName: "photo")

        // TMDB 기본 이미지 URL 구성
        let baseURL = "https://image.tmdb.org/t/p/w780"
        let urlString = baseURL + posterPath

        guard let url = URL(string: urlString) else { return }

        // 간단한 비동기 이미지 로딩
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
