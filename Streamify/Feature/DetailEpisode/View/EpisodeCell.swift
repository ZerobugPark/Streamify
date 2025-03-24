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
    
    let viewModel = EpisodeCellViewModel()
    var disposeBag = DisposeBag()
    let dramaRepository: any DramaRepository = RealmDramaRepository()
//    init(viewModel: EpisodeCellViewModel) {
//        self.viewModel = viewModel
//        super.init()
//    }
    
    let imageView = BaseImageView()
    let titleLabel = BaseLabel(fontSize: .body_bold_14, color: .baseWhite)
    let timeLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    let dateLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseLightGray)
    
    let checkButton = ActionButton(title: "", image: .checkmark)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    private func bind() {
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.checkButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    func configure(_ item: EpisodeData) {
        titleLabel.text = item.title
        timeLabel.text = item.time
        dateLabel.text = item.date
        overviewLabel.text = item.overview
    }
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, timeLabel, dateLabel, overviewLabel, checkButton)
        imageView.backgroundColor = .darkGray
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.top.equalTo(imageView)
            make.trailing.equalTo(checkButton).offset(-5)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.trailing.equalTo(checkButton).offset(-5)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.bottom.equalTo(imageView)
            make.trailing.equalTo(checkButton).offset(-5)
        }
        overviewLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        bind()
    }
    
}
