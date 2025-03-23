//
//  DramaEpisodeCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit

class DramaEpisodeCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
//    
//    class DramaEpisodeCell: UICollectionViewCell {
//        static let id = "DramaEpisodeCell"
//        
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            contentView.addSubview(imageView)
//            contentView.addSubview(titleLabel)
//            contentView.addSubview(countLabel)
//            
//            imageView.snp.makeConstraints { make in
//                make.top.leading.trailing.equalToSuperview()
//                make.height.equalToSuperview().multipliedBy(0.6)
//            }
//            titleLabel.snp.makeConstraints { make in
//                make.top.equalTo(imageView.snp.bottom).offset(4)
//                make.leading.trailing.equalToSuperview()
//            }
//            countLabel.snp.makeConstraints { make in
//                make.top.equalTo(titleLabel.snp.bottom).offset(2)
//                make.leading.trailing.equalToSuperview()
//            }
//            
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            titleLabel.textColor = .white
//            titleLabel.font = .systemFont(ofSize: 14)
//            countLabel.textColor = .gray
//            countLabel.font = .systemFont(ofSize: 12)
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        func configure(with episode: DramaEpisode) {
//            imageView.image = episode.image
//            titleLabel.text = episode.title
//            countLabel.text = "\(episode.episodeCount)개 에피소드"
//        }
//    }
    
}
