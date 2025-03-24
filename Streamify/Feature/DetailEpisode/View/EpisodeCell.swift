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
    let titleLabel = BaseLabel(fontSize: .body_bold_24, color: .baseWhite)
    let timeLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    let dateLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    let overviewLabel = BaseLabel(fontSize: .body_regular_13, color: .baseWhite)
    
    let checkButton = ActionButton(title: "", image: .checkmark)
    
    override func configureHierarchy() {
        addSubviews(imageView, titleLabel, timeLabel, dateLabel, overviewLabel, checkButton)
        imageView.backgroundColor = .darkGray
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.height.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    private func bind() {
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.checkButton.isSelected.toggle()
//                dramaRepository.toggleEpisodeWatched(drama: <#T##DramaTable#>, episode: <#T##Episodes#>)
            }
            .disposed(by: disposeBag)
    }
    
}
