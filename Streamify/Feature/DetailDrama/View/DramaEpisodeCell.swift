//
//  DramaEpisodeCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DramaEpisodeCell: BaseCollectionViewCell {
    private let imageView = BaseImageView()
    private let titleLabel = BaseLabel(fontSize: .body_bold_14, color: .baseWhite)
    private let countLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    private let progressBar = ProgressBar()
    private let containerView = UIView()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        addSubviews(titleLabel, countLabel, containerView)
        containerView.addSubviews(imageView, progressBar)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
        progressBar.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(imageView)
        }
    }
    
    override func configureView() {
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
    }
    
    func configure(_ item: DramaEpisode) {
        titleLabel.text = item.title
        countLabel.text = "\(item.episodeCount)개 에피소드"
        imageView.image = UIImage(systemName: "photo")
        let baseURL = Config.shared.secureURL + Config.PosterSizes.w154.rawValue
        let urlString = baseURL + item.image

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
        
        progressBar.progress = item.dramaTable.episodeProgress(for: item.dramaTable.seasons[item.seasonNumber])
        
        NotificationCenterManager.progress.addObserver()
            .bind(with: self) { owner, _ in
                owner.progressBar.progress = item.dramaTable.episodeProgress(for: item.dramaTable.seasons[item.seasonNumber])
            }
            .disposed(by: disposeBag)
    }
    
}
