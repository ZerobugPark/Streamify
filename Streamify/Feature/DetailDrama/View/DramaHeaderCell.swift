//
//  DramaHeaderCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit

import SnapKit

final class DramaHeaderCell: BaseCollectionViewCell {
    private let backdropImage = BaseImageView()
    private let titleLabel = BaseLabel(fontSize: .body_bold_24, color: .baseWhite)
    private let infoLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    private let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    
    override func configureHierarchy() {
        addSubviews(backdropImage, titleLabel, infoLabel, overviewLabel)
        backdropImage.contentMode = .scaleAspectFill
    }
    
    override func configureLayout() {
        backdropImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImage.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func configure(_ item: DramaHeader) {
        titleLabel.text = item.title
        infoLabel.text = item.info
        overviewLabel.text = item.overview
        backdropImage.image = UIImage(systemName: "photo")

        let baseURL = Config.shared.secureURL + Config.BackdropSizes.w780.rawValue
        let urlString = baseURL + item.backdropImage

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.backdropImage.image = image
            }
        }.resume()
    }
    
    override func configureView() {
        backdropImage.backgroundColor = .gray
    }
    
}
