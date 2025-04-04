//
//  StorageCollectionViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class StorageCollectionViewCell: BaseCollectionViewCell {
   
    private let image = BaseImageView(radius: 10)
    private let titleLabel = BaseLabel(fontSize: .body_bold_14, color: .baseWhite)
    private let genreLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    private let progressBar = ProgressBar()
    
    override func configureHierarchy() {
        contentView.addSubviews(image,progressBar,titleLabel,genreLabel)
    }
    
    override func configureLayout() {
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1.0 / 1.5)
        }
        
        progressBar.snp.makeConstraints { make in
            make.bottom.equalTo(image.snp.bottom).offset(-4)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(4)
            make.width.equalTo(image.snp.width).offset(-8)
            make.leading.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
        
        
    }
    
    override func configureView() {
        titleLabel.numberOfLines = 1
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    func setupUI(_ data: DramaTable) {
        
        titleLabel.text = data.title
        genreLabel.text = data.genre
        
        if data.watchingProgress == 0.0 {
            progressBar.alpha = 0
        } else {
            progressBar.alpha = 1
            progressBar.progress = data.watchingProgress
        }
        
        let urlString = Config.shared.secureURL + Config.BackdropSizes.w300.rawValue + data.imagePath
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
              guard let self = self else { return } // 셀이 사라졌으면 이미지 설정 안 함
              
              if let error = error {
                  print("Error loading image: \(error.localizedDescription)")
                  return
              }
              
              guard let data = data, let image = UIImage(data: data) else {
                  print("Invalid image data")
                  return
              }
              
              DispatchQueue.main.async {
                  self.image.image = image
              }
          }.resume()
        
        
    }
}


