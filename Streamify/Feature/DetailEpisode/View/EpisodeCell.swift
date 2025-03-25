//
//  EpisodeCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class EpisodeCell: BaseCollectionViewCell {
    
    private var viewModel: EpisodeCellViewModel?
    var disposeBag = DisposeBag()
    
    let imageView = BaseImageView(radius: 5)
    let titleLabel = BaseLabel(fontSize: .body_bold_14, color: .baseWhite)
    let timeLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    let dateLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    
    let checkButton = ActionButton(title: "", image: .checkmark)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkButton.isSelected = false
        disposeBag = DisposeBag()
        bind()
    }
    
    private func bind() {
        guard let viewModel else { return }
        let input = EpisodeCellViewModel.Input(
            checkButtonTap: checkButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.checkButtonTap
            .drive(with: self) { owner, value in
                owner.checkButton.isSelected = value
            }
            .disposed(by: disposeBag)
    }
    
    func configure(_ item: EpisodeData, _ episode: Episodes) {
        titleLabel.text = item.title
        timeLabel.text = item.time
        dateLabel.text = item.date
        overviewLabel.text = item.overview
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
        
        self.viewModel = EpisodeCellViewModel(episode: episode)
        checkButton.isSelected = episode.isWatched
        bind()
    }
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, timeLabel, dateLabel, overviewLabel, checkButton)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(100)
            make.width.equalTo(160)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.top.equalTo(imageView)
            make.trailing.equalTo(checkButton).offset(-5)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.trailing.equalTo(checkButton).offset(-5)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.bottom.equalTo(imageView)
            make.trailing.equalTo(checkButton).offset(-5)
        }
        overviewLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
}
